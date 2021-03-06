# coding=utf-8
import xadmin
from xadmin.plugins.batch import BatchChangeAction
from xadmin.plugins.actions import DeleteSelectedAction
from models import ProjectSetting, VendorSetting
from order.models import OrderNote
from base.adminx import *
from project.models import *
from report.vendor_account import getAllCompanyIds, getAllVendor

class ProjectSettingAdmin(object):
    list_display = ('project', 'online_before_amount')
    list_display_links = ('project',)
    list_editable = ['online_before_amount']
    search_fields = ['project__name']
    actions = [DeleteSelectedAction, ]
    
    
    def formfield_for_dbfield(self, db_field, **kwargs):
        if db_field.name == 'project':
            company_ids = getAllCompanyIds(self)
            kwargs['queryset'] = Project.objects.filter(company_id__in=company_ids)
        field = super(ProjectSettingAdmin, self).formfield_for_dbfield(db_field, **kwargs)
        return field




class VendorSettingAdmin(object):
    list_display = ('vendor', 'company', 'online_before_owed_amount', 'online_before_owed_invoice')
    list_display_links = ('vendor',)
    list_editable = ['online_before_owed_amount', 'online_before_owed_invoice']
    search_fields = ['vendor__name']
    actions = [DeleteSelectedAction, ]
    
    def formfield_for_dbfield(self, db_field, **kwargs):
        if db_field.name == 'vendor':
            kwargs['queryset'] = getAllVendor(self)
        field = super(VendorSettingAdmin, self).formfield_for_dbfield(db_field, **kwargs)
        return field
    
class OrderNoteAdmin(AbstractObjectAdmin):
    show_bookmarks = False
    list_display = ('name', )
    actions = [DeleteSelectedAction,]  


xadmin.site.register(ProjectSetting, ProjectSettingAdmin)    
xadmin.site.register(VendorSetting, VendorSettingAdmin) 
xadmin.site.register(OrderNote, OrderNoteAdmin) 
        
        


