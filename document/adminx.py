# coding=utf-8
import datetime
import datetime 

from django.db.models import Q
from django.db.models import Sum
from django.http import HttpResponse
from django.template.response import TemplateResponse
from django.utils.datastructures import SortedDict

from document.models import *
from document.models import Document, DocumentLineItem, PROJECT_TYPE
from material.models import *
from mmcp.actions import PROJECT_MATERIAL_APPLY, PurchaseOrderSelectedAction
from mmcp.constant import *
from mmcp.util import get_audit_comments_by_document_id, has_audit_comment_by_document_id, doAudit, handle_audit, handle_audit, getItem, canSubmitToApproveForDocument, isGroup, PROJECT_GROUP, PURCHASE_GROUP, canEditAuditQty, canDeleteOrAddDocumentLine, is_closed, isClosedByDocument, getProjects, getPurchasedQuantity, isPurchCompleted
from models import Document, DocumentLineItem
from payment.models import *
from project.models import Project
from report.project_apply import get_project_apply_list
from workflow.models import Route, Item, ITEM_START, ITEM_APPROVED, ITEM_REJECTED
from workflow.workflow import Workflow, hasApprovedBySelf
import xadmin
from xadmin.plugins.actions import DeleteSelectedAction
from xadmin.plugins.batch import BatchChangeAction
from xadmin.views.base import CommAdminView , ModelAdminView
from xadmin.views.list import ResultRow
from xplugin.views.list import MyListAdminView


class DocumentAdmin(object):
    
    def get_context(self):
        context = super(DocumentAdmin, self).get_context()
        context['has_add_permission']= ''
        return context
    
    def getDocumentLines(self, instance):
        return "<a href='/document/documentlineitem/?_rel_document__id__exact=%s'>%s</a>" % (instance.id, instance.document_id)
    getDocumentLines.short_description = u"单据编号"
    getDocumentLines.allow_tags = True
    getDocumentLines.is_column = True
    
    
    def submitToApprove(self, instance):
        if canSubmitToApproveForDocument(self, instance.document_id):
            return "<button type='submit' class='default btn btn-primary col-xs-7' name='_submit'  value='%s'/>提交申请 </button>" % instance.document_id
        else:
            return ""  
    submitToApprove.short_description = u"操作"
    submitToApprove.allow_tags = True
    submitToApprove.is_column = True
    
    def post_response(self, *args, **kwargs):
        document_id = self.request.POST.get('_submit')
        if document_id:
            self.message_user(u"提交申请成功", 'success')
        else:
            return super(DocumentAdmin, self).post_response(self, *args, **kwargs)
        
    
    def post(self, request, *args, **kwargs):
        document_id = request.POST.get('_submit')
        if document_id:
            route = Route.objects.filter(route_name = PROJECT_MATERIAL_APPLY, company = self.user.company)[0]
            document = Document.objects.filter(document_id = document_id)[0]
            document.create_date = datetime.datetime.now()
            document.save(update_fields=['create_date'])
            item = Item.objects.get_or_create(document = document,
                                       item_name = PROJECT_MATERIAL_APPLY,
                                       route = route,
                                       user = self.user)
            #重新发起申请
            if item[0].status == ITEM_REJECTED:
                workflow = Workflow()
                workflow.reApplyWorkflow(item[0], self.user, '')
            else:#新申请
                workflow = Workflow()      
                workflow.applyWorkflow(route, item[0], self.user)
            
        return super(DocumentAdmin, self).post(request, *args, **kwargs)
            
    def get_list_queryset(self):
        if isGroup(self, PROJECT_GROUP):
            #包括其他项目负责人申请的要料单
            return super(DocumentAdmin, self).get_list_queryset().filter(project__users__in = [self.user])
        else:
            return super(DocumentAdmin, self).get_list_queryset().filter(project__company = self.user.company, document_id__startswith ='PM')  
    
    #审批没有通过可以被删除, 且只能删除自己申请的单据       
    def filter_queryset(self, queryset):
        ids = []
        for obj in queryset:
            ids.append(obj.id)
            
        items = Item.objects.filter(document__id__in = ids)
        ids = []
        for item in items:
            if item.status != ITEM_REJECTED:
                ids.append(item.document.id) 
               
        queryset = queryset.exclude(id__in = ids).filter(user=self.user)
        return queryset
        
    def delete_models(self, queryset):
        queryset = self.filter_queryset(queryset)
        if len(queryset) > 0:
            super(DocumentAdmin, self).delete_models(queryset)
             
    use_related_menu = False
    list_display = ('project', 'getDocumentLines', 'document_type', 'user', 'create_date', 'submitToApprove')
    search_fields = ['document_id', 'project__name']
    list_filter = ['project__name', 'create_date',]
    batch_fields = ('document_id',)
    list_display_links = ('none',)
    actions = [DeleteSelectedAction,]
    
class DocumentLineItemAdmin(object):
    def post(self, request, *args, **kwargs):
        
        if 'action' in request.POST and 'approval' == request.POST['action']:
            return doAudit(self, request)
        else:
            return super(DocumentLineItemAdmin, self).post(request, *args, **kwargs)
        
        
    def block_customer_modal(self, context, nodes):
        path = self.request.get_full_path()
        if 'action=approval' in path and 'csrftoken' in self.request.COOKIES and '_rel_document__id__exact' in self.request.GET:
            csrf_token = self.request.COOKIES['csrftoken']
            document_id = self.request.GET['_rel_document__id__exact']
            return APPROVAL_FORM_HTML.format(csrf_token, document_id)
            
            
            
    def getTotalPurchasedQuantity(self, instance):
        return getPurchasedQuantity(self, instance)
    getTotalPurchasedQuantity.short_description = u"已采购量"
    getTotalPurchasedQuantity.allow_tags = True
    getTotalPurchasedQuantity.is_column = True
    
    def getFileUrl(self, instance):
        return "<a href='/files/%s'>%s</a>" % (instance.file, instance.file)
    getFileUrl.short_description = u"附件"
    getFileUrl.allow_tags = True
    getFileUrl.is_column = True
    
    def get_list_display_links(self):
        list_display_links = super(DocumentLineItemAdmin, self).get_list_display_links()
        if "_rel_document__id__exact" in self.request.GET:
            document_id = self.request.GET['_rel_document__id__exact']
            item = getItem(document_id)
            if item is not None:
                if (item.status != ITEM_REJECTED):
                    list_display_links = ('none')
        else:
            list_display_links = ('none')
        return list_display_links
        
    
    @property
    def list_editable(self):
        if "_rel_document__id__exact" in self.request.GET:
            document_id = self.request.GET['_rel_document__id__exact']
            item = getItem(document_id)
            if item is not None:
                document = Document.objects.get(id = document_id)
                
                #自己已经审批通过不能再修改
                if hasApprovedBySelf(self, item):
                    return []
                
                #采购部门可以修改实际采购名称
                if (item.status == ITEM_APPROVED):
                    if isGroup(self, PURCHASE_GROUP) and (document and not isPurchCompleted(document)):
                        return ['material']
                    else:
                        return []
                if (item.status == ITEM_REJECTED) and isGroup(self, PROJECT_GROUP):
                    return ['expected_date', 'expected_quantity', 'brand','comments']
                    
                if canEditAuditQty(self):
                    return ['expected_date', 'audit_quantity', 'approval_comments']
            else:
                if isGroup(self, PROJECT_GROUP):
                    return ['expected_date', 'expected_quantity', 'brand', 'comments']       
            
    def get_list_queryset(self):
        if isGroup(self, PROJECT_GROUP):
            return super(DocumentLineItemAdmin, self).get_list_queryset().filter(document__user=self.user).order_by('-document__id',
                                                                                                                    "projectMaterial__project__id", 
                                                                                                                    "projectMaterial__material__category__name", 
                                                                                                                    "projectMaterial__material__name",
                                                                                                                    "projectMaterial__material__specification")  
        else:
            return super(DocumentLineItemAdmin, self).get_list_queryset().filter(document__project__company = self.user.company).order_by('-document__id',
                                                                                                                       "projectMaterial__project__id", 
                                                                                                                       "projectMaterial__material__category__name", 
                                                                                                                       "projectMaterial__material__name",
                                                                                                                       "projectMaterial__material__specification")
            
           
    @property
    def global_actions(self):
        if canDeleteOrAddDocumentLine(self):
            return [DeleteSelectedAction]
        else:
            return []
    
    @property
    def batch_fields(self):
        if "_rel_document__id__exact" in self.request.GET:
            document_id = self.request.GET['_rel_document__id__exact']
            item = getItem(document_id)
            if item is not None:
                if (item.status == ITEM_APPROVED):
                    return []
                if (item.status == ITEM_REJECTED) and isGroup(self, PROJECT_GROUP):
                    return ['expected_date', ]
                    
            else:
                if isGroup(self, PROJECT_GROUP):
                    return ['expected_date', ] 
    
    
    def get_list_display(self):
        list_display = super(DocumentLineItemAdmin, self).get_list_display()
        
            
        #工程人员不能看到预算量
        isProjectGroup = isGroup(self, PROJECT_GROUP)
        if isProjectGroup:
            if 'getQuantity' in list_display:
                list_display.remove('getQuantity')
        
        isApproved = False
        if "_rel_document__id__exact" in self.request.GET:
            document_id = self.request.GET['_rel_document__id__exact']
            item = getItem(document_id)
            if item is not None:
                if (item.status == ITEM_APPROVED):
                    isApproved = True
            
            #已修改审批结束或是采购部门才可以修改实际采购材料
            if not (isApproved or isGroup(self, PURCHASE_GROUP)):
                if 'material' in list_display:
                    list_display.remove('material')
            
            #审批结束没有结束 不用显示 已采购量， 已到货数量
            if not isApproved:
                if 'getTotalPurchasedQuantity' in list_display:
                    list_display.remove('getTotalPurchasedQuantity')
                if 'posted_quantity' in list_display:
                    list_display.remove('posted_quantity')
                if isProjectGroup:
                    if 'audit_quantity' in list_display:
                        list_display.remove('audit_quantity')
                    if 'approval_comments' in list_display:
                        list_display.remove('approval_comments')
                        
        return list_display
        
    def get_context(self):
        context = super(DocumentLineItemAdmin, self).get_context()
        if not canDeleteOrAddDocumentLine(self):
            context['has_add_permission']= ''
        return context
    
    @property
    def actions(self):
        actions=[]
        #闭合的采购单不能再被修改
        if "close" in self.request.GET:
            order_id = self.request.GET['close']
            if is_closed(order_id):
                return actions
        
        if "_rel_document__id__exact" in self.request.GET:
            document_id = self.request.GET['_rel_document__id__exact']
            item = getItem(document_id)
            if item is not None:
                document = Document.objects.get(id = document_id)
                if (item.status == ITEM_REJECTED) and isGroup(self, PROJECT_GROUP):
                    actions.append(BatchChangeAction)
                    
                if (item.status == ITEM_APPROVED) and isGroup(self, PURCHASE_GROUP) and (document and not isPurchCompleted(document)):
                    actions.append(PurchaseOrderSelectedAction)      
            else:
                if isGroup(self, PROJECT_GROUP):
                    actions.append(BatchChangeAction)
        return actions
    
    
    def get_model_form(self, **kwargs):
        form = super(DocumentLineItemAdmin, self).get_model_form(**kwargs)
        if "_rel_document__id__exact" in self.request.GET:
            document_id = self.request.GET['_rel_document__id__exact']
            #过滤项目材料
            try:     
                document = Document.objects.get(id = document_id)
            except Document.DoesNotExist:
                document = None
            if document:
                form.base_fields['projectMaterial'].queryset = form.base_fields['projectMaterial'].queryset.filter(project=document.project)
            
        return form
        
                    
    def get_actions(self):
        actions = super(DocumentLineItemAdmin, self).get_actions()
        if "_rel_document__id__exact" in self.request.GET:
            document_id = self.request.GET['_rel_document__id__exact']
            item = getItem(document_id)
            if item is not None:
                if (item.status == ITEM_REJECTED) and isGroup(self, PROJECT_GROUP):
                    actions.append(BatchChangeAction)
                      
            else:
                if isGroup(self, PROJECT_GROUP):
                    actions.append(BatchChangeAction)
        return actions   
    
    def delete_models(self, queryset):
        documentLine = queryset[0]
        documentLines = DocumentLineItem.objects.filter(document = documentLine.document)
        #If all of the documentLine will be delete then the document should be also delete
        if len(queryset) == len(documentLines):
            documentLine.document.delete()
            
        super(DocumentLineItemAdmin, self).delete_models(queryset) 
    
    def block_results_bottom_action(self, context, nodes):
        #工程人员才可以用 下一步操作
        if '_rel_document__id__exact' in self.params and self.params['_rel_document__id__exact'] and isGroup(self, PROJECT_GROUP):
            doc = Document.objects.get(id = self.params['_rel_document__id__exact'])
            url = '/document/document/?_q_=%s' % doc.document_id
            return "<a class='dropdown-toggle navbar-right btn btn-success'  href='%s'>下一步</a>" % url
    
    @property
    def exclude(self):
        #工程人员不能添加预算量
        if isGroup(self, PROJECT_GROUP):
            return ('posted_quantity', 'audit_quantity', 'approval_comments', 'material')
        else:
            return ['posted_quantity', 'audit_quantity']                    
        
        
    hidden_menu = True
    use_related_menu = False
    context_object_name = "files"
    list_display = ['document', 'getProjectName', 'getProjectMaterial', 'material', 'expected_date','getQuantity', 'expected_quantity', 'audit_quantity', 'getTotalPurchasedQuantity', 'posted_quantity', 'brand', 'comments', 'getFileUrl', 'approval_comments']
    list_display_links = []
    list_filter = ['projectMaterial__project__name', 'document']
    search_fields = ['document__document_id', 'projectMaterial__material__name']
    batch_fields = ('expected_date', 'brand') 
    list_per_page = 100
   
    
#项目申请单统计
class ProjectApplyListView(CommAdminView):
    need_site_permission = True
    list_template = 'views/project_apply_list.html'
    
    def get_media(self):
        media = super(ProjectApplyListView, self).get_media()
        media = media + self.vendor('xadmin.widget.select.js', 'datepicker.js', 'datepicker.css', 'xadmin.widget.datetime.js', 'select.js', 'select.css', 'xadmin.plugin.actions.js', 'xadmin.plugins.css')
        return media
    
            
    def get(self, request, *args, **kwargs):
        context = super(ProjectApplyListView, self).get_context()
        projects = getProjects(self)
        context['projects'] = projects
        context['categories'] = Category.objects.all()
        return TemplateResponse(request, self.list_template, context,
                                current_app=self.admin_site.name)
        
    def post(self, request, *args, **kwargs):
        project = ''
        if 'project' in request.POST:
            project = request.POST['project']
        
        category = ''
        if 'category' in request.POST:
            category = request.POST['category']
        
        material_name = ''
        if 'material_name' in request.POST:
            material_name = request.POST['material_name']
        
        response = self.get(request)
        context = response.context_data
        result = get_project_apply_list(project, category, material_name)
        
        if len(result['lines']) == 0:
                result['message'] ='没有查询到结果！' 
          
        context['result'] = result
        return response  
    
    

#要料单
class RequestOrder(MyListAdminView): 
    
    def get_media(self):
        media = super(RequestOrder, self).get_media()
        media = media + self.vendor('my.js', 'xadmin.form.css')
        return media
     
    def getAuditList(self, instance):
        return "<a href='/workflow/audit/%s/list/'><i class='fa fa-calendar'></i></a>" % instance
    getAuditList.short_description = u"审核日志"
    getAuditList.allow_tags = True
    getAuditList.is_column = True 
    
    def getAuditComments(self, instance):
        if has_audit_comment_by_document_id(instance.document_id):
            data = get_audit_comments_by_document_id(instance.document_id)
            title = '意见'
            return ('<a data-content="%s" class="details-handler" rel="tooltip" title="%s"><i class="fa fa-info-circle"></i></a>'
                                         % (data, title))
        else:
            return ''
    getAuditComments.short_description = u"审核意见"
    getAuditComments.allow_tags = True
    getAuditComments.is_column = True     
     
     
    def getDocumentLines(self, instance):
        #项目申请URL
        url = "<a href='/document/documentlineitem/?_rel_document__id__exact=%s'>%s</a>" % (instance.id, instance.document_id)
        return url
     
    getDocumentLines.short_description = u"单据编号"
    getDocumentLines.allow_tags = True
    getDocumentLines.is_column = True
     
    model = Document
    list_display_links = ('none',)
    list_display = ('project', 'getDocumentLines', 'user', 'getAuditList', 'getAuditComments', 'purch_status')
    list_filter = ['project__name', 'purch_status']
    list_editable = ['purch_status',]
    search_fields = ['document_id']
    
    def get_list_display(self):
        list_display = super(RequestOrder, self).get_list_display()
        if 'related_link' in list_display:
            list_display.remove('related_link')
             
        return list_display
     
    def queryset(self):
        items = Item.objects.filter(document__project__company = self.user.company, document__document_id__startswith = 'PM', status = ITEM_APPROVED)
        document_ids= []
        for item in items:
            document_ids.append(item.document.id)
        return super(RequestOrder, self).queryset().filter(id__in = document_ids).order_by('purch_status', '-document_id')  
    
      
xadmin.site.register(Document, DocumentAdmin)            
xadmin.site.register(DocumentLineItem, DocumentLineItemAdmin)
xadmin.site.register_view(r'^document/request/order/$',RequestOrder , name='document/request/order')
xadmin.site.register_view(r'^project/apply/list/$',ProjectApplyListView , name='project/apply/list')
