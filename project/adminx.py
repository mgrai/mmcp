# coding=utf-8
import xadmin
from xadmin.plugins.batch import BatchChangeAction
from xadmin.plugins.actions import DeleteSelectedAction
from xadmin.views.base import CommAdminView 
from xadmin.adminx import AbstractObjectAdmin
from django.template.response import TemplateResponse
from django.http import HttpResponse, HttpResponseRedirect
from django.utils.safestring import mark_safe
from django.db.models import Q
from models import *
from mmcp.util import *
from mmcp.constant import *
from mmcp.actions import *



class ProjectAdmin(object):
    
    def getProjectMaterials(self, instance):
        return "<a href='/project/projectmaterial/?_rel_project__id__exact=%s'><i class='fa fa-link'></i></a>" % (instance.id)
    getProjectMaterials.short_description = u"项目材料"
    getProjectMaterials.allow_tags = True
    getProjectMaterials.is_column = True
    
    
    use_related_menu = False
    list_display = ('name', 'short_name','estimate_user', 'users', 'amount', 'bid_date', 'company', 'getProjectMaterials')
    list_display_links = ('name',)
    aggregate_fields = {"amount": "sum",}
    
    search_fields = ['name']
    list_filter = ['company__name', 'bid_date']

    actions = [BatchChangeAction, ]
    batch_fields = ('name',) 
    style_fields = {'users': 'checkbox-inline',}
    
    def get_model_form(self, **kwargs):
        form = super(ProjectAdmin, self).get_model_form(**kwargs)
        #过滤company
        if 'company' in form.base_fields:
            form.base_fields['company'].queryset = form.base_fields['company'].queryset.filter(name=self.user.company.name)
        return form
    
    def formfield_for_dbfield(self, db_field, **kwargs):
        if db_field.name == 'company':
            kwargs['queryset'] = Company.objects.filter(name=self.user.company.name)
        field = super(ProjectAdmin, self).formfield_for_dbfield(db_field, **kwargs)
        return field
    
    @property
    def wizard_form_list(self):
         
        list = [
            ('项目特征', ('name', 'short_name', 'company', 'construct_unit', 'property', 'scale', 'estimate_user', 'users' )),
            ('合同条款', ('amount', 'contract_format', 'payment_type', 'bid_date', 'start_date', 'end_date', 'settlement_method', 'settlement_amount', 'file')),
        ]
        #预算部门经理不需要指定项目负责人
        if isGroup(self, ESTIMATE_GROUP):
            list = [
            ('项目特征', ('name','full_name', 'company', 'construct_unit', 'property', 'scale', 'estimate_user' )),
            ('合同条款', ('amount', 'contract_format', 'payment_type', 'bid_date', 'start_date', 'end_date', 'settlement_method', 'settlement_amount', 'file')),
        ]
        return list
            
        
    @property
    def exclude(self):
        if isGroup(self, ESTIMATE_GROUP):
            return ['users',]
        
    def queryset(self):
        #工程人员只能看到自己的项目
        if isGroup(self, PROJECT_GROUP):
            return super(ProjectAdmin, self).queryset().filter(users__in = [self.user])
        else:
            return super(ProjectAdmin, self).queryset()
   

class ProjectMaterialAdmin(object):
    def get_context(self):
        context = super(ProjectMaterialAdmin, self).get_context()
        context['has_add_permission']= False
        return context
    
    def block_nav_btns(self, context, nodes):
        queryset = SelectedLineItem.objects.filter(user = self.user)
        if queryset.count() > 0:
            url = '/project/selectedlineitem/'
            nodes.append(mark_safe('<a href="%s" class="btn btn-primary">%s</a>' % (url, '完成材料选择')))
            
            nodes.append('&nbsp;&nbsp;')
            
        if hasattr(self, 'params') and '_rel_project__id__exact' in self.params:
            project_id = self.params['_rel_project__id__exact']
            batch_add_url = '/material/material/?project_id=%s' %project_id
            nodes.append(mark_safe('<a href="%s" class="btn btn-primary">%s</a>' % (batch_add_url, '批量增加材料')))
            
        
        

    def get_model_form(self, **kwargs):
        form = super(ProjectMaterialAdmin, self).get_model_form(**kwargs)
        
        #过滤 project
        if isGroup(self, PROJECT_GROUP) and 'project' in form.base_fields:
            form.base_fields['project'].queryset = form.base_fields['project'].queryset.filter(users__in = [self.user])
            
        return form
    
    def save_models(self):
        try:
            p = super(ProjectMaterialAdmin, self).queryset().filter(project=self.new_obj.project, material=self.new_obj.material)[0]
        except IndexError:
            p = None
        
        #项目经理不能累加材料    
        if p is not None and not isGroup(self, PROJECT_GROUP):
            p.quantity = p.quantity + self.new_obj.quantity
            p.save()
        else:
            #项目经理新加的材料
            if isGroup(self, PROJECT_GROUP) and self.new_obj.quantity == 0:
                self.new_obj.quantity = MAX_PROJECT_MATERIAL_QANTITY
                
            
            return super(ProjectMaterialAdmin, self).save_models()
     
    def queryset(self):
        #工程人员只能看到自己的项目
        if isGroup(self, PROJECT_GROUP):
            queryset = super(ProjectMaterialAdmin, self).queryset().filter(project__users__in = [self.user])
        else:
            queryset = super(ProjectMaterialAdmin, self).queryset()
        
        return queryset
    
    def get_list_queryset(self):
        queryset = super(ProjectMaterialAdmin, self).get_list_queryset()
        
        #分配材料到项目时需要把加入的材料放在列表最前面，方便输入数量，单价等信息
        if 'batch_add' in self.request.GET:
            queryset = queryset.order_by('-id')
        return queryset
        
         
    def get_list_display(self):
        list_display = super(ProjectMaterialAdmin, self).get_list_display()
        #工程人员可以看到预算量
        if isGroup(self, PROJECT_GROUP):
            list_display.remove('quantity')
            list_display.remove('price')
            list_display.remove('max_price')
            list_display.remove('total')
            list_display.insert(2, 'get_quantity')
        return list_display
    
    @property
    def aggregate_fields(self):
        #工程人员不能看到总价
        if not isGroup(self, PROJECT_GROUP):
            return {"total": "sum",}
        
    @property
    def exclude(self):
        #工程人员不能添加预算量
        if isGroup(self, PROJECT_GROUP):
            return ['quantity', 'total', 'price', 'max_price']
        else:
            return ['total']
    
    @property
    def actions(self):
        actions=[]
        #只有工程人员才能申请项目材料
        if isGroup(self, PROJECT_GROUP):
            actions.append(ProjectMaterialSelectedAction)
        return actions
    
    def get_applied_quantity_lable(self, instance):
        return 0
#         return get_received_quantity(self, instance)
    get_applied_quantity_lable.short_description = "已申请量"
    get_applied_quantity_lable.allow_tags = True
    get_applied_quantity_lable.is_column = True
    
    def get_quantity(self, instance):
        quantity = ''
        if instance.quantity != 99999:
            quantity = instance.quantity
        return quantity
    get_quantity.short_description = "预算量"
    get_quantity.allow_tags = True
    get_quantity.is_column = True
    
    show_bookmarks = False
    use_related_menu = False
    hidden_menu = True
    list_display = ('project', 'material', 'quantity', 'price', 'max_price', 'total', 'get_applied_quantity_lable')
    list_display_links = ('material',)
    
    search_fields = ['project__name', 'material__category__name', 'material__name', 'material__specification']
    list_editable = ['quantity', 'price', 'max_price']
    list_filter = ['material__category', 'project']
    batch_fields = ('material',)


class SelectedLineItemAdmin(object):
    list_display = ('getProject', 'getMaterial',)
    exclude = ('user',)
    actions = [ApplyProjectMaterialSelectedAction, DeleteSelectedAction]
    
    def queryset(self):
        #工程人员只能看到自己的项目
        return super(SelectedLineItemAdmin, self).queryset().filter(user = self.user)
    
    def get_model_form(self, **kwargs):
        form = super(SelectedLineItemAdmin, self).get_model_form(**kwargs)
        form.base_fields['projectMaterial'].queryset = form.base_fields['projectMaterial'].queryset.filter(project__users__in = [self.user])
        return form
    
    def save_models(self):
        self.new_obj.user = self.user
        return super(SelectedLineItemAdmin, self).save_models()

        
xadmin.site.register(Project, ProjectAdmin)         
xadmin.site.register(ProjectMaterial, ProjectMaterialAdmin)
xadmin.site.register(SelectedLineItem, SelectedLineItemAdmin)        