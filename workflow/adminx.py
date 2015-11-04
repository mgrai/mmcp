# coding=utf-8
import re

from django import forms
from django.http import  HttpResponseRedirect
from django.template import loader
from django.template.response import TemplateResponse
from django.utils.translation import ugettext_lazy as _

from document.models import PAYMENT_TYPE
from mmcp.actions import AuditSelectedAction
from mmcp.util import handle_audit, has_audit_comment_by_item_id, get_audit_comments_by_item_id, getAuditComments, buildPaymentItems, buildProjectItems
from models import Route, Actor, ActorUser, Item, TaskList, TaskHistory, AUDIT_STATUS, APPROVED, ITEM_START, ITEM_REJECTED, ITEM_APPROVING, PAYMENT_ROUTE, PROJECT_ROUTE
from payment.models import Payment
from workflow import Workflow, getMyApplayItems, getMyHandleItems, getMyHandledItems, handlePayment
import xadmin
from xadmin.adminx import AbstractObjectAdmin
from xadmin.models import CompanyGroup
from xadmin.plugins.actions import ActionPlugin
from xadmin.plugins.batch import BatchChangeAction
from xadmin.sites import site
from xadmin.views import ListAdminView, ModelFormAdminView, UpdateAdminView
from xadmin.views.base import CommAdminView , ModelAdminView, inclusion_tag
from xadmin.views.list import ResultRow
from xplugin.views.list import MyListAdminView
from xplugin.views.pagination import MyPaginationView
from company.models import *


class RouteAdmin(AbstractObjectAdmin):
    use_related_menu = False
    list_display = ('route_name', 'group')
    list_display_links = ('route_name',)

    search_fields = ['route_name']
    
    exclude = ['company',]
    

    actions = [BatchChangeAction, ]
    batch_fields = ('route_name',)
    
    def formfield_for_dbfield(self, db_field, **kwargs):
        if db_field.name == 'group':
            kwargs['queryset'] = CompanyGroup.objects.filter(company=self.user.company)
        field = super(RouteAdmin, self).formfield_for_dbfield(db_field, **kwargs)
        return field
    
    def queryset(self):
        return super(RouteAdmin, self).queryset().filter(company=self.user.company)



class ActorAdmin(object):
    show_bookmarks = False
    use_related_menu = False
    list_display = ('route', 'actor_name', 'sort_order', )
    list_display_links = ('actor_name',)

    search_fields = ['route__route_name']

    actions = [BatchChangeAction, ]
    batch_fields = ('actor_name',)
    
    def formfield_for_dbfield(self, db_field, **kwargs):
        if db_field.name == 'route':
            kwargs['queryset'] = Route.objects.filter(company=self.user.company)
        field = super(ActorAdmin, self).formfield_for_dbfield(db_field, **kwargs)
        return field
    
    def queryset(self):
        return super(ActorAdmin, self).queryset().filter(route__company=self.user.company)


class ActorUserAdmin(object):
    show_bookmarks = False
    list_display = ('actor', 'user',)
    list_display_links = ('actor',)

    search_fields = ['actor']

    actions = [BatchChangeAction, ]
    batch_fields = ('actor',) 
    
    def formfield_for_dbfield(self, db_field, **kwargs):
        if db_field.name == 'actor':
            kwargs['queryset'] = Actor.objects.filter(route__company=self.user.company)
            
        if db_field.name == 'user':
            kwargs['queryset'] = Employee.objects.filter(company=self.user.company)
            
        field = super(ActorUserAdmin, self).formfield_for_dbfield(db_field, **kwargs)
        return field
    
    def queryset(self):
        return super(ActorUserAdmin, self).queryset().filter(actor__route__company=self.user.company)


class ReAppalyForm (forms.ModelForm):
    comments = forms.CharField(label=u'意见', widget=forms.Textarea,required=False )
    
    
    class Meta:
        model = Item
        
class AuditForm (forms.ModelForm):
    audit = forms.ChoiceField(label=u'审核', widget=forms.Select, choices=AUDIT_STATUS)
    comments = forms.CharField(label=u'意见', widget=forms.Textarea,required=False )
    
    
    class Meta:
        model = Item

class AuditItemsAdmin(UpdateAdminView):
    exclude = ('route','document', 'item_name', 'user', 'status')
    form = AuditForm
    model = Item
    
    def doAuditPost(self, request):
        item_ids = request.session.get('items_ids')
        
        form = self.form(request.POST)
        audit = form['audit'].value()
        comments = form['comments'].value()
        
        queryset = Item.objects.filter(pk__in = item_ids)
        for item in queryset:
            workflow = Workflow()
            if str(APPROVED) == audit:
                handlePayment(item)
                workflow.approveWorkflow(item, self.user, comments)
            else:
                workflow.rejectWorkflow(item, self.user, comments)
        return HttpResponseRedirect("/workflow/my/handle/tasks/")
    
    def post(self, request, *args, **kwargs):
        return self.doAuditPost(request)
    
class ReApplyItemAdmin(UpdateAdminView):
    readonly_fields = ('document', 'item_name', 'user', 'status')
    exclude = ('route',)
    form = ReAppalyForm
    model = Item
    
    def doReApplyPost(self, request):
        item = self.org_obj
        form = self.form(request.POST)
        comments = form['comments'].value()
        workflow = Workflow()
        workflow.reApplyWorkflow(item, self.user, comments)
        return HttpResponseRedirect("/")
    
    def post(self, request, *args, **kwargs):
        return self.doReApplyPost(request)
    
          
class ItemAdmin(object):
    readonly_fields = ('document', 'item_name', 'user', 'status')
    exclude = ('route',)
    form = AuditForm
    hidden_menu = True
    
    
    def doAuditPost(self, request):
        item = self.org_obj
        form = self.form(request.POST)
        audit = form['audit'].value()
        comments = form['comments'].value()
        return handle_audit(self, item, audit, comments )
    
    
    def post(self, request, *args, **kwargs):
        return self.doAuditPost(request)
    

    
    
#审核日志    
class AuditList(MyListAdminView):
    
    model = TaskHistory
    hidden_menu = True
    use_related_menu = False
    show_bookmarks = False
    global_actions = []
    list_display = ('item', 'actor', 'status', 'user', 'create_date', 'comments')
    list_display_links = ('none',)
    show_my_detail_fields =['comments']
    
    def queryset(self):
        document_id = self.request.get_full_path().split('/')[3]
        return super(AuditList, self).queryset().filter(item__document__document_id=document_id)
 
   
class MyTask(MyListAdminView):
    def getDocumentLines(self, instance):
        #项目申请URL
        url = "<a href='/document/documentlineitem/?_rel_document__id__exact=%s'>%s</a>" % (instance.document.id, instance.document.document_id)
        #付款申请URL
        if PAYMENT_TYPE == instance.document.document_type:
            payment = Payment.objects.filter(payment_id = instance.document.document_id)[0]
            url = "<a href='/payment/payment/%s/update/?action=reapply'>%s</a>" % (payment.id, instance.document.document_id)
            
        return url
    
    getDocumentLines.short_description = u"单据编号"
    getDocumentLines.allow_tags = True
    getDocumentLines.is_column = True
    
    
    def getAuditList(self, instance):
        return "<a href='/workflow/audit/%s/list/'><i class='fa fa-calendar'></i></a>" % instance
    getAuditList.short_description = u"审核日志"
    getAuditList.allow_tags = True
    getAuditList.is_column = True
    
    def getProjectName(self, instance):
        return (instance.document.project or '')
    getProjectName.short_description = u"项目名称"
    getProjectName.allow_tags = True
    getProjectName.is_column = True
    
    def getAuditCommentsLable(self, instance):
        return getAuditComments(instance)
    getAuditCommentsLable.short_description = u"审核意见"
    getAuditCommentsLable.allow_tags = True
    getAuditCommentsLable.is_column = True 
    
    def get_media(self):
        media = super(MyTask, self).get_media()
        media = media + self.vendor('my.js', 'xadmin.form.css')
        return media     

    model = Item
    list_display = ('getProjectName', 'getDocumentLines', 'route', 'status', 'getAuditList', 'getAuditCommentsLable')
    list_display_links = ('route',)
    search_fields = ['document__document_id', 'document__project__name']
    list_filter = ['route',]    
    
#我申请的工作
class MyApplayTasks(MyTask):
    
    def get_list_display(self):
        list_display = super(MyApplayTasks, self).get_list_display()
        if 'related_link' in list_display:
            list_display.remove('related_link')
        return list_display
    
    
    def queryset(self):
        if self.user.is_superuser:
            return super(MyApplayTasks, self).queryset()
        return super(MyApplayTasks, self).queryset().filter(user = self.user)
    
    list_display_links = ('none',)
     
    
               
#待我处理的工作    
class MyHandleTasks(CommAdminView):
    need_site_permission = True
    tasks_template = 'views/my_handle_tasks.html'
     
    def get_media(self):
        media = super(MyHandleTasks, self).get_media()
        media = media + self.vendor('datepicker.js', 'datepicker.css', 'xadmin.widget.datetime.js', 'select.js', 'select.css', 'xadmin.plugin.actions.js', 'xadmin.plugins.css')
        media = media + self.vendor('xadmin.plugin.details.js','my.js', 'xadmin.form.css')        
        return media
    
    def get(self, request, *args, **kwargs):
        context = super(MyHandleTasks, self).get_context()
        payment_items = getMyHandleItems(self, PAYMENT_ROUTE)
        project_items = getMyHandleItems(self, PROJECT_ROUTE)
        context['payment_result'] = buildPaymentItems(payment_items)
        context['project_items'] = buildProjectItems(project_items)
        context['item_size'] = project_items.count() +  payment_items.count()
        
        return TemplateResponse(request, self.tasks_template, context,
                                current_app=self.admin_site.name)
     
    def post(self, request, *args, **kwargs):
        if 'action' in request.POST:
            return self.combine_approval(request)
        else:
            return self.get(request)
    
    def combine_approval(self, request):  
        selected = request.POST.getlist('_selected_action')
        if not selected:
            # Reminder that something needs to be selected or nothing will happen
            msg = _("Items must be selected in order to perform "
                            "actions on them. No items have been changed.")
            self.message_user(msg)
        else:
            self.request.session['items_ids'] = selected
            return HttpResponseRedirect("/workflow/audit/%s/items" %selected[0], self)
                    
        return self.get(request)

    
#已处理的工作    
class MyHandledTasks(MyTask):
    
    
    
    list_display = ('getProjectName', 'getDocumentLines', 'user', 'route', 'status', 'getAuditList', 'getAuditCommentsLable')
    list_display_links = ('none',)
    list_filter = ['route', 'document__project', 'document__create_date'] 
    search_fields = ['document__document_id', 'document__project__name', 'document__user__first_name', 'document__user__last_name']
    
    def get_list_display(self):
        list_display = super(MyHandledTasks, self).get_list_display()
        if 'related_link' in list_display:
            list_display.remove('related_link')
        return list_display
    
    def queryset(self):        
        histories = TaskHistory.objects.filter(user = self.user).select_related('item')
        item_ids= []
        for history in histories:
            item_ids.append(history.item.id)
        
        return super(MyHandledTasks, self).queryset().filter(id__in=item_ids)   
    
    
xadmin.site.register_view(r'^workflow/my/handle/tasks/$',MyHandleTasks , name='workflow/my/handle/tasks')        
xadmin.site.register_view(r'^workflow/my/handled/tasks/$',MyHandledTasks , name='workflow/my/handled/tasks')        
xadmin.site.register_view(r'^workflow/my/apply/tasks/$',MyApplayTasks , name='workflow/my/apply/tasks')
xadmin.site.register_view(r'^workflow/audit/(.+)/list/$',AuditList , name='workflow/audit/list')        
xadmin.site.register_view(r'^workflow/audit/(.+)/items/$',AuditItemsAdmin , name='workflow/audit/items')        
xadmin.site.register_view(r'^workflow/item/(.+)/reapply/$',ReApplyItemAdmin , name='workflow/item/reapply')        
xadmin.site.register(Route, RouteAdmin)  
xadmin.site.register(Actor, ActorAdmin)  
xadmin.site.register(ActorUser, ActorUserAdmin)
xadmin.site.register(TaskHistory, AuditList)     
xadmin.site.register(Item, ItemAdmin)     

