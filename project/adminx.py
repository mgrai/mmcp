# coding=utf-8
import xadmin
from xadmin.plugins.batch import BatchChangeAction
from xadmin.plugins.actions import DeleteSelectedAction
from xadmin.views.base import CommAdminView 
from xadmin.adminx import AbstractObjectAdmin
from django.template.response import TemplateResponse
from django.http import HttpResponse, HttpResponseRedirect
from django.db.models import Q
from models import *
from mmcp.utils import *


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
   
        
xadmin.site.register(Project, ProjectAdmin)         