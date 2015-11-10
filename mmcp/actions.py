# coding=utf-8
from django.http import  HttpResponseRedirect
from xadmin.views.base import filter_hook
from xadmin.plugins.actions import BaseActionView
from document.models import *
from workflow.models import *
from workflow.workflow import *
from order.models import *
from mmcp.util import *
from project.models import *
from mmcp.constant import *
import datetime 

PROJECT_MATERIAL_APPLY = u"项目材料申请"
PAYMENT_APPLY = u"付款申请"

#把材料分配到项目里面
class MaterialSelectedAction(BaseActionView):

    action_name = "material_selected"
    description = u'材料选择'

    model_perm = 'view'
    icon = 'fa fa-check-square-o'

    @filter_hook
    def do_action(self, queryset):
        
        for obj in queryset:
            project_id = self.request.GET['project_id'] 
            assign_material_to_project(self, project_id, obj)
                
        
        self.message_user(u"所选材料已分配到项目中！", 'info') 
        
        url = "/project/projectmaterial/?_rel_project__id__exact=%s&batch_add=1" % (project_id)     
        return HttpResponseRedirect(url)
    
class ProjectMaterialSelectedAction(BaseActionView):

    action_name = "project_material_selected"
    description = u'材料选择'

    model_perm = 'view'
    icon = 'fa fa-check-square-o'

    @filter_hook
    def do_action(self, queryset):
        
        for obj in queryset:
            SelectedLineItem.objects.create(projectMaterial = obj, user = self.user)
        
        url = '/project/projectmaterial/'
        if '_rel_project__id__exact' in self.request.GET:
            project_id = self.request.GET['_rel_project__id__exact']
            url += '?_rel_project__id__exact=' +project_id
        
        self.message_user(u"所选项目材料已提交！", 'info')        
        return HttpResponseRedirect(url)
    
class ApplyProjectMaterialSelectedAction(BaseActionView):

    action_name = "apply_project_material_selected"
    description = u'合并申请项目材料'

    model_perm = 'view'
    icon = 'fa fa-check-square-o'
    
    def is_same_project(self, queryset):
        result = True
        project_name = queryset[0].getProject()
        for obj in queryset:
            if project_name != obj.getProject():
                result = False
                break
        
        return result
                
            
            
        

    @filter_hook
    def do_action(self, queryset):
        
        if self.is_same_project(queryset):
        
            now = datetime.datetime.now()
            now = now.strftime("%Y%m%d%H%M%S")
            
            company_id = str(self.user.company.id).zfill(4)
            
            document_id = "PM" + company_id + now
            document_type = PROJECT_TYPE
            
            document = Document.objects.create(document_id = document_id, 
                                    document_type = document_type,
                                    user = self.user,
                                    project = queryset[0].projectMaterial.project)
            
            for obj in queryset:
                DocumentLineItem.objects.create(document = document,
                                                projectMaterial = obj.projectMaterial)
            queryset.delete()    
            return HttpResponseRedirect("/document/documentlineitem/?_rel_document__id__exact=%s" %(document.id))
        else:
            
            self.message_user("请按单个项目提交申请，不能同时多个不同项目进行材料申请！", 'error')
            return HttpResponseRedirect("/project/selectedlineitem/")
            
    
    
class PurchaseOrderSelectedAction(BaseActionView):
 
    action_name = "purchase_order_selected"
    description = u'合并生成采购单'
 
    model_perm = 'view'
    icon = 'fa fa-check-square-o'
 
    def do_action(self, queryset):
         
        now = datetime.datetime.now()
        now = now.strftime("%Y%m%d%H%M%S")
        
        company_id = str(self.user.company.id).zfill(4)
         
        order_id = "PO" + company_id + now
        documentLine = queryset[0]
        document = documentLine.document
        project = documentLine.projectMaterial.project
        company = project.company
         
        #检查能否进行项目材料采购
        created = False
        for obj in queryset:
            quantity = getAvailableQuantity(self, obj)
            #可用量大于0 或者申请负的数量去退货    
            if quantity > 0 or obj.expected_quantity < 0:
                created = True
                break
             
         
        if created:
            order = Order.objects.create(order_id = order_id, 
                                     document = document,
                                     company = company,
                                     project = project,
                                     user = self.user)
            for obj in queryset:
                quantity = getAvailableQuantity(self, obj)    
                if quantity > 0 or obj.expected_quantity < 0:
                    OrderLine.objects.create(order = order,
                                             documentLineItem = obj,
                                             purchase_quantity = quantity,
                                             brand = obj.brand)
             
            url = "/order/orderline/?_rel_order__id__exact=%s" %(order.id)
        else:
            self.message_user(u"所选项目材料已采购完成！", 'info')
            url = "/document/documentlineitem/?_rel_document__id__exact=%s" %(document.id)
             
         
         
        return HttpResponseRedirect(url)
     
     
class OrderLineSelectedAction(BaseActionView):
 
    action_name = "order_lines_selected"
    description = u'合并生成到货单'
 
    model_perm = 'view'
    icon = 'fa fa-check-square-o'
 
    @filter_hook
    def do_action(self, queryset):
        order_id = ''
        for obj in queryset.reverse():
            received_quantity = getTotalReceivedQuantity(self, obj)
            quantity = obj.purchase_quantity - received_quantity
            #到货 剩余的量 或者采购量为负表示退货
            if quantity > 0 or obj.purchase_quantity < 0:
                ReceivingLine.objects.create(orderLine = obj, receiving_quantity = quantity)
                order_id = obj.order.order_id
                 
        if order_id == '':
            self.message_user(u"所选项目材料已到货！", 'info')
            url = "/order/orderline/?_rel_order__id__exact=%s" %(queryset[0].order.id)
        else:
            url = "/order/receivingline/?_rel_orderLine__order__id__exact=%s" %(obj.order.id)
             
        return HttpResponseRedirect(url)
         
class AuditSelectedAction(BaseActionView):
 
    action_name = "audit_selected"
    description = u'合并审批'
 
    model_perm = 'view'
    icon = 'fa fa-check-square-o'
     
    def do_action(self):    
        return HttpResponseRedirect("/workflow/audit/items")           

