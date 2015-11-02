# coding=utf-8
import xadmin
from xadmin import views
from xadmin.layout import Main, TabHolder, Tab, Fieldset, Row, Col, AppendedText, \
    Side
from xadmin.plugins.batch import BatchChangeAction
from xadmin.plugins.inline import Inline
from django.db.models import Q, Sum
from django.contrib.auth.models import Group, Permission
from xplugin.user.models import UserInfo
from xadmin.plugins.actions import DeleteSelectedAction
from hehe.actions import ApplyProjectMaterialSelectedAction, ProjectMaterialSelectedAction
from hehe.util import isGroup,getProjects, getMateriales, PROJECT_GROUP, PURCHASE_GROUP, ESTIMATE_GROUP_MANAGER, ESTIMATE_GROUP, get_received_quantity
from hehe.constant import MAX_PROJECT_MATERIAL_QANTITY

from models import Company, Project, ProjectMaterial, SelectedLineItem
from material.adminx import MaterialPriceView
from material.models import Category, Specification, Unit, Material, Vendor, Brand
from document.models import Document, DocumentLineItem 
from order.models import Order, OrderLine,ReceivingLine, CheckAccount, Invoice, OrderNote, CheckAccountDetail
from payment.models import PaymentProperty, PaymentType, Payment,DoPayemnt
from workflow.models import Item, Route, Actor, ActorUser
from setting.models import ProjectSetting, VendorSetting
from report.adminx import ProjectReceivingListView, ProjectReceivingExportExcelView, VendorAccountListView, VendorAccountExportExcelView, ProjectUsedListView, ProjectUsedExportExcelView, PaymentSummaryView, PaymentSummaryExportExcelView

from django.template.response import TemplateResponse
from django.http import HttpResponse, HttpResponseRedirect
from xadmin.views.base import CommAdminView , ModelAdminView
from django.utils.safestring import mark_safe


class IndexView(CommAdminView):
    list_template = 'views/index.html'
    
    def get(self, request, *args, **kwargs):
        context = super(IndexView, self).get_context()
        
        return TemplateResponse(request, self.list_template, context,
                                current_app=self.admin_site.name)

class BaseSetting(object):
    enable_themes = False
    use_bootswatch = True
xadmin.site.register(views.BaseAdminView, BaseSetting)


class GlobalSetting(object):
    global_search_models = [Project,]
    site_title = u'合和机电管理系统'
    
    def get_site_menu(self):
        return (
            {'title': '与我相关', 'icon': 'fa fa-user',  'menus':(
                {'title': '我的申请', 'icon': 'fa fa-plus-square', 'url': '/workflow/my/apply/tasks', 'perm': self.get_model_perm(Item, 'view'),},
                {'title': '待我处理', 'icon': 'fa fa-question-circle', 'url': '/workflow/my/handle/tasks', 'perm': self.get_model_perm(Item, 'handle')},
                {'title': '已处理', 'icon': 'fa fa-suitcase', 'url': '/workflow/my/handled/tasks', 'perm': self.get_model_perm(Item, 'handled')},
            )},
                
            {'title': '项目管理', 'icon': 'fa fa-briefcase',  'menus':(
                {'title': Project._meta.verbose_name, 'icon': 'fa fa-briefcase', 'url': self.get_model_url(Project, 'changelist'), 'perm': self.get_model_perm(Project, 'view')},
#                 {'title': ProjectMaterial._meta.verbose_name, 'icon': 'fa fa-building-o', 'url': self.get_model_url(ProjectMaterial, 'changelist'), 'perm': self.get_model_perm(ProjectMaterial, 'view')},
                {'title': '价格查询', 'icon': 'fa fa-search', 'url': '/material/price', 'perm': self.get_model_perm(OrderLine, 'search_price')},
            )},
             
            {'title': '材料管理', 'icon': 'fa fa-tasks',  'menus':(
                {'title': Category._meta.verbose_name, 'icon': 'fa fa-th-large', 'url': self.get_model_url(Category, 'changelist'), 'perm': self.get_model_perm(Category, 'change')},
#                 {'title': Specification._meta.verbose_name, 'icon': 'fa fa-trello', 'url': self.get_model_url(Specification, 'changelist'), 'perm': self.get_model_perm(Specification, 'change')},
                {'title': Unit._meta.verbose_name, 'icon': 'fa fa-flask', 'url': self.get_model_url(Unit, 'changelist'), 'perm': self.get_model_perm(Unit, 'change')},
                {'title': Material._meta.verbose_name, 'icon': 'fa fa-tasks', 'url': self.get_model_url(Material, 'changelist'), 'perm': self.get_model_perm(Material, 'view')},
                {'title': Brand._meta.verbose_name, 'icon': 'fa fa-sun-o', 'url': self.get_model_url(Brand, 'changelist'), 'perm': self.get_model_perm(Brand, 'change')},
                {'title': Vendor._meta.verbose_name, 'icon': 'fa fa-user', 'url': self.get_model_url(Vendor, 'changelist'), 'perm': self.get_model_perm(Vendor, 'change')},
            )},
            {'title': '项目申请', 'icon': 'fa fa-file-text-o', 'perm': self.get_model_perm(Document, 'view'), 'menus':(
                {'title': '材料选择', 'icon': 'fa fa-list-alt', 'url': self.get_model_url(SelectedLineItem, 'changelist'), 'perm': self.get_model_perm(SelectedLineItem, 'change')},                                                                                                   
                {'title': '项目申请单', 'icon': 'fa fa-file-text-o', 'url': self.get_model_url(Document, 'changelist'), 'perm': self.get_model_perm(Document, 'change')},
                {'title': '项目申请单名细', 'icon': 'fa fa-align-justify', 'url': self.get_model_url(DocumentLineItem, 'changelist'), 'perm': self.get_model_perm(DocumentLineItem, 'change')},
                {'title': '项目申请单统计', 'icon': 'fa fa-list-alt', 'url': '/project/apply/list'},
            )},
            {'title': '采购管理', 'icon': 'fa fa-truck', 'perm': self.get_model_perm(Order, 'view'), 'menus':(
                {'title': '要料单', 'icon': 'fa fa-file-text-o', 'url': '/document/request/order', 'perm': self.get_model_perm(DocumentLineItem, 'change')},
                {'title': '采购单', 'icon': 'fa fa-align-justify', 'url': self.get_model_url(Order, 'changelist'), 'perm': self.get_model_perm(Order, 'change')},
                {'title': '采购名细', 'icon': 'fa fa-align-justify', 'url': self.get_model_url(OrderLine, 'changelist'), 'perm': self.get_model_perm(OrderLine, 'change')},
                {'title': '到货单', 'icon': 'fa fa-align-justify', 'url': self.get_model_url(ReceivingLine, 'changelist'), 'perm': self.get_model_perm(ReceivingLine, 'view')},
                {'title': '对帐', 'icon': 'fa fa-check-square-o', 'url': '/report/vendor/account/list', 'perm': self.get_model_perm(ReceivingLine, 'change')},
                {'title': '发票', 'icon': 'fa fa-money', 'url': self.get_model_url(Invoice, 'changelist'), 'perm': self.get_model_perm(Invoice, 'view')},
            )},
            {'title': '付款管理', 'icon': 'fa fa-cny',  'menus':(
                {'title': '付款申请', 'icon': 'fa fa-money', 'url': self.get_model_url(Payment, 'changelist'), 'perm': self.get_model_perm(Payment, 'view')},
                {'title': '付款单', 'icon': 'fa fa-money', 'url': self.get_model_url(DoPayemnt, 'changelist'), 'perm': self.get_model_perm(DoPayemnt, 'view')},
#                 {'title': '付款单', 'icon': 'fa fa-table', 'url': '/payment/order', 'perm': self.get_model_perm(Payment, 'view')},
                {'title': '支付方式', 'icon': 'fa fa-th-large', 'url': self.get_model_url(PaymentType, 'changelist'), 'perm': self.get_model_perm(PaymentType, 'change')},
                {'title': '款项属性', 'icon': 'fa fa-th-large', 'url': self.get_model_url(PaymentProperty, 'changelist'), 'perm': self.get_model_perm(PaymentProperty, 'change')},
            )}, 
             {'title': '报表', 'icon': 'fa fa-file-text-o', 'menus':(
                {'title': '到货单', 'icon': 'fa fa-truck', 'url': '/report/project/receiving/list', 'perm': self.get_model_perm(Order, 'view')},
                {'title': '对帐单', 'icon': 'fa fa-align-justify', 'url': self.get_model_url(CheckAccount, 'changelist'), 'perm': self.get_model_perm(CheckAccount, 'view')},
                {'title': '对账单名细', 'icon': 'fa fa-align-justify', 'url': self.get_model_url(CheckAccountDetail, 'changelist'), 'perm': self.get_model_perm(CheckAccountDetail, 'view')},
                {'title': '工程用量', 'icon': 'fa fa-indent', 'url': '/report/project/used/list', 'perm': self.get_model_perm(Order, 'view'),},
                {'title': '付款汇总', 'icon': 'fa fa-list-alt', 'url': '/report/payment/summary', 'perm': self.get_model_perm(Order, 'view'),},
                
            )},  
            {'title': '基础值设置', 'icon': 'fa fa-file-text-o', 'perm': self.get_model_perm(ProjectSetting, 'view'), 'menus':(
                {'title': '项目设置', 'icon': 'fa fa-file-text-o', 'url': self.get_model_url(ProjectSetting, 'changelist'), 'perm': self.get_model_perm(ProjectSetting, 'view')},
                {'title': '供应商设置', 'icon': 'fa fa-file-text-o', 'url': self.get_model_url(VendorSetting, 'changelist'), 'perm': self.get_model_perm(VendorSetting, 'view')},
                {'title': '采购单注意事项', 'icon': 'fa fa-file-text-o', 'url': self.get_model_url(OrderNote, 'changelist'), 'perm': self.get_model_perm(OrderNote, 'view')},
                
            )},   
            {'title': '系统管理', 'icon': 'fa fa-wrench',  'menus':(
                {'title': Company._meta.verbose_name, 'icon': 'fa fa-home', 'url': self.get_model_url(Company, 'changelist'), 'perm': self.get_model_perm(Company, 'change')},
                {'title': '部门管理', 'icon': 'fa fa-users', 'url': self.get_model_url(Group, 'changelist'), 'perm': self.get_model_perm(Group, 'change')},
                {'title': '用户管理', 'icon': 'fa fa-user', 'url': self.get_model_url(UserInfo, 'changelist'), 'perm': self.get_model_perm(UserInfo, 'change')},
                {'title': '权限管理', 'icon': 'fa fa-lock', 'url': self.get_model_url(Permission, 'changelist'), 'perm': self.get_model_perm(Permission, 'change')},
            )},
            {'title': '工作流', 'icon': 'fa fa-folder-o',  'menus':(
                {'title': '流程', 'icon': 'fa fa-folder-o', 'url': self.get_model_url(Route, 'changelist'), 'perm': self.get_model_perm(Route, 'change')},
                {'title': '步骤', 'icon': 'fa fa-check-square-o', 'url': self.get_model_url(Actor, 'changelist'), 'perm': self.get_model_perm(Actor, 'change')},
                {'title': '步骤处理人', 'icon': 'fa fa-user', 'url': self.get_model_url(ActorUser, 'changelist'), 'perm': self.get_model_perm(ActorUser, 'change')},
            )},
        )
        
    menu_style = 'accordion'
    
xadmin.site.register(views.CommAdminView, GlobalSetting)


class CompanyAdmin(object):
    show_bookmarks = False
    list_display = ('name', 'short_name', 'phone', 'fax', 'zip', 'address')
    list_display_links = ('name',)

    search_fields = ['name']

    actions = [BatchChangeAction, ]
    batch_fields = ('name',)

    class Meta:
        model = Item
        
        
class ProjectAdmin(object):
    
    def getProjectMaterials(self, instance):
        return "<a href='/project/projectmaterial/?_rel_project__id__exact=%s'><i class='fa fa-link'></i></a>" % (instance.id)
    getProjectMaterials.short_description = u"项目材料"
    getProjectMaterials.allow_tags = True
    getProjectMaterials.is_column = True
    
    @property
    def list_editable(self):
        if isGroup(self, PURCHASE_GROUP):
            return ['one_month_amount', 'two_month_amount',]
        
    
    show_bookmarks = False
    use_related_menu = False
    list_display = ('name', 'full_name','estimate_user', 'users', 'amount', 'bid_date', 'company', 'getProjectMaterials', 'one_month_amount', 'two_month_amount')
    list_display_links = ('name',)
    aggregate_fields = {"amount": "sum",}
    
    search_fields = ['name']
    list_filter = ['company__name', 'bid_date']

    actions = [BatchChangeAction, ]
    batch_fields = ('name',) 
    style_fields = {'users': 'checkbox-inline',}
    
    @property
    def wizard_form_list(self):
        
        list = [
            ('项目特征', ('name', 'full_name', 'company', 'construct_unit', 'property', 'scale', 'estimate_user', 'users' )),
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
            return ['quantity', 'total', 'price']
        else:
            return ['total']
    
    @property
    def actions(self):
        actions=[]
        #只有工程人员才能申请项目材料
        if isGroup(self, PROJECT_GROUP):
            actions.append(ProjectMaterialSelectedAction)
        return actions
    
    def get_received_quantity_lable(self, instance):
        return get_received_quantity(self, instance)
    get_received_quantity_lable.short_description = "到货量"
    get_received_quantity_lable.allow_tags = True
    get_received_quantity_lable.is_column = True
    
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
    list_display = ('project', 'material', 'quantity', 'price', 'total', 'get_received_quantity_lable')
    list_display_links = ('material',)
    
    search_fields = ['project__name', 'material__category__name', 'material__name', 'material__specification']
    list_editable = ['quantity', 'price']
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

        
xadmin.site.register(Company, CompanyAdmin)  
xadmin.site.register(Project, ProjectAdmin)  
xadmin.site.register(ProjectMaterial, ProjectMaterialAdmin)
xadmin.site.register(SelectedLineItem, SelectedLineItemAdmin)

xadmin.site.register_view(r"^report/project/receiving/list$", ProjectReceivingListView, name='report/project/receiving/list')        
xadmin.site.register_view(r"^report/project/receiving/export$", ProjectReceivingExportExcelView, name='report/project/receiving/export')        
xadmin.site.register_view(r"^report/vendor/account/list$", VendorAccountListView, name='report/vendor/account/list')        
xadmin.site.register_view(r"^report/vendor/account/export$", VendorAccountExportExcelView, name='report/vendor/account/export')        
xadmin.site.register_view(r"^report/project/used/list$", ProjectUsedListView, name='report/project/used/list')        
xadmin.site.register_view(r"^report/project/used/export$", ProjectUsedExportExcelView, name='report/project/used/export')        
xadmin.site.register_view(r"^report/payment/summary/$", PaymentSummaryView, name='report/payment/summary')        
xadmin.site.register_view(r"^report/payment/summary/export$", PaymentSummaryExportExcelView, name='report/payment/summary/export')        
xadmin.site.register_view(r"^material/price/$", MaterialPriceView, name='material/price')        
# xadmin.site.register_view(r"^$", IndexView, name='index')        

