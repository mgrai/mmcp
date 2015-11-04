# coding=utf-8
import xadmin
import datetime 
from xadmin.plugins.batch import BatchChangeAction
from xadmin.plugins.actions import DeleteSelectedAction
from models import PaymentType, PaymentProperty, Payment, DoPayemnt
from xadmin.layout import Main, TabHolder, Tab, Fieldset, Row, Col, AppendedText, Side
from xadmin.views import ListAdminView
from django import forms
from xplugin.user.models import UserInfo
from workflow.models import Route, Actor, ActorUser, Item, TaskList, TaskHistory, AUDIT_STATUS, APPROVED, ITEM_START,ITEM_REJECTED, ITEM_APPROVING, ITEM_APPROVED
from document.models import Document, PAYMENT_TYPE
from workflow.models import ITEM_STATUS
from workflow.workflow import Workflow
from workflow.adminx import MyTask
from hehe.actions import PAYMENT_APPLY
from hehe.util import doAudit, close_payment, isGroup,hasTaskHistory, PURCHASE_GROUP, ACCOUNT_GROUP_MANAGER, ACCOUNT_GROUP, paymentAuditStatus, getOwedAmountByYear, getOwedAmount, getPaymentAuditStatus, getItemByDocumentId
from django.utils.translation import ugettext as _
from django.db.models.query import QuerySet
from django.template import loader
from django.http import HttpResponseRedirect
from hehe.constant import APPROVAL_NO_FORM_HTML
from .export import ExportPaymentView

class PaymentTypeAdmin(object):
    show_bookmarks = False
    list_display = ('name',)
    list_display_links = ('name',)

    search_fields = ['name']
    actions = [DeleteSelectedAction,]


class PaymentPropertyAdmin(object):
    show_bookmarks = False
    list_display = ('name',)
    list_display_links = ('name',)

    search_fields = ['name']
    actions = [DeleteSelectedAction,]

        
class PaymentAdmin(object):
    
    def block_after_fieldsets(self, context, node):
        path = self.request.get_full_path()
        if 'action=handle' in path:
            context.update({
                "show_save": False,
                "show_save_as_new": False,
                "show_save_and_add_another": False,
                "show_save_and_continue": False,
            })
            
            payment_id = path.split('/')[3]
            payment = Payment.objects.get(id = payment_id)
            document = Document.objects.filter(document_id = payment.payment_id)[0]
            csrf_token = self.request.COOKIES['csrftoken']
            return APPROVAL_NO_FORM_HTML.format(csrf_token, document.id)
            
    def save_models(self):
        if not bool(self.new_obj.payment_id):
            #新增加
            now = datetime.datetime.now()
            now_str = now.strftime("%Y%m%d%H%M%S")
            payment_id = "PT" + now_str
            self.new_obj.payment_id = payment_id
            self.new_obj.owed_amount = getOwedAmount(int(now.strftime("%Y")), int(now.strftime("%m")) -1,  self.new_obj.vendor)
            self.new_obj.owed_amount_after_payment = self.new_obj.owed_amount - self.new_obj.payment_amount
        else:
            #更新
            payment_id = self.new_obj.payment_id
            now = datetime.datetime.strptime(payment_id[2:], "%Y%m%d%H%M%S").date()
            
            self.new_obj.owed_amount = getOwedAmount(int(now.strftime("%Y")), int(now.strftime("%m")) -1,  self.new_obj.vendor)
            payment_amount = self.new_obj.applied_amount if bool(self.new_obj.applied_amount) else  self.new_obj.payment_amount
            self.new_obj.owed_amount_after_payment = self.new_obj.owed_amount - payment_amount
        
            
        return super(PaymentAdmin, self).save_models()
    
    def doAction(self, instance):
        if not instance.is_applied or paymentAuditStatus(instance, ITEM_REJECTED):
            return "<button type='submit' class='default btn btn-primary col-xs-9' name='_submit'  value='%s'/>提交申请 </button>" % instance.payment_id
        elif paymentAuditStatus(instance, ITEM_APPROVED):
            return "<a href='/payment/exportExcel/?id=%s'><i class='fa fa-cloud-download'></i></a>" % instance.id
        else:
            return ''
    doAction.short_description = u"操作"
    doAction.allow_tags = True
    doAction.is_column = True
    
    def getStatus(self, instance):
        status = getPaymentAuditStatus(instance.payment_id)
        if status != '':
            return ITEM_STATUS[status][1]
        else:
            return status
        
    getStatus.short_description = u"审批状态"
    getStatus.allow_tags = True
    getStatus.is_column = True
    
    def getAppliedAmount(self, instance):
        result = ''
        if paymentAuditStatus(instance, ITEM_APPROVING) or paymentAuditStatus(instance, ITEM_APPROVED):
            result = instance.applied_amount if instance.applied_amount else instance.payment_amount
        return result
    getAppliedAmount.short_description = u"审批金额"
    getAppliedAmount.allow_tags = True
    getAppliedAmount.is_column = True
    
    def getAuditList(self, instance):
        result = ''
        if hasTaskHistory(instance.payment_id):
            result = "<a href='/workflow/audit/%s/list/'><i class='fa fa-calendar'></i></a>" % instance.payment_id
        return result
    getAuditList.short_description = u"审核日志"
    getAuditList.allow_tags = True
    getAuditList.is_column = True
    
    def doReapply(self):
        url = '/payment/payment/?_q_=%s'%self.new_obj.payment_id
        return HttpResponseRedirect(url)
    
    def post_response(self, *args, **kwargs):
        path = self.request.get_full_path()
        if 'action=handle' in path:
            return doAudit(self, self.request)
        elif 'action=reapply' in path:
            return self.doReapply()
        else:
            return super(PaymentAdmin, self).post_response(*args, **kwargs)
            
    def post(self, request, *args, **kwargs):
            payment_id = request.POST.get('_submit')
            if payment_id:
                now = datetime.datetime.now()
                payment = Payment.objects.filter(payment_id = payment_id)[0]
                if not payment.is_applied:
                    payment.create_time = now
                    payment.is_applied = True
                    payment.save(update_fields=['create_time', 'is_applied'])
                
                route = Route.objects.filter(route_name = PAYMENT_APPLY)[0]
                
                document = Document.objects.get_or_create(document_id = payment_id, defaults = {'document_type':PAYMENT_TYPE,
                                                                                                'user':self.user,
                                                                                                'create_date':now})
                
                item = Item.objects.get_or_create(document = document[0],
                                                   item_name = PAYMENT_APPLY,
                                                   route = route,
                                                   user = self.user)
                #重新发起申请
                if item[0].status == ITEM_REJECTED:
                    workflow = Workflow()
                    workflow.reApplyWorkflow(item[0], self.user, '')
                else:#新申请
                    workflow = Workflow()      
                    workflow.applyWorkflow(route, item[0], self.user)
                self.message_user(u"提交申请成功", 'success')
            return super(PaymentAdmin, self).post(request, *args, **kwargs)
    
        
    
    def get_context(self):
        context = super(PaymentAdmin,self).get_context()
        #已提交申请的付款单不能被修改和删除
        if (hasattr(self, 'obj') and self.obj.is_applied):
            context.update({
            'show_delete_link': False,
            'has_delete_permission': False,
            'has_change_permission': False,
            'has_view_permission': True,
            })
            
        else:
            #已被拒绝的申请可以修改
            if (hasattr(self, 'org_obj') and paymentAuditStatus(self.org_obj, ITEM_REJECTED)):
                context['has_change_permission'] = True
                context['has_delete_permission'] = False
                context['show_delete_link'] = False
        
        path = self.request.get_full_path()
        if 'action=reapply' in path:
            context.update({
            "show_save": True,
            "show_save_as_new": False,
            "show_save_and_add_another": False,
            "show_save_and_continue": False,
            'show_delete_link': False,
            })
        return context
    
    #已在审批过程中的付款单不能被删除
    def filter_queryset(self, queryset):
        for payment in queryset:
            status = getPaymentAuditStatus(payment.payment_id)
            if status != '' and ITEM_STATUS[status][1] != ITEM_STATUS[0][1]:
                queryset = queryset.exclude(payment_id = payment.payment_id)
        return queryset
    
    def delete_Items(self, queryset):
        for payment in queryset:
            items = Item.objects.filter(document__document_id = payment.payment_id)
            for item in items:
                item.document.delete()
                item.delete()
            
    def delete_models(self, queryset):
        queryset = self.filter_queryset(queryset)
        if len(queryset) > 0:
            self.delete_Items(queryset)
            super(PaymentAdmin, self).delete_models(queryset)
    
        
            
    @property
    def readonly_fields(self):
        result = ('owed_amount', 'owed_amount_after_payment', 'applied_amount')
        
        #在审批完成
        if hasattr(self, 'org_obj') and paymentAuditStatus(self.org_obj, ITEM_APPROVED):
            result = ('company', 'vendor', 'content', 'owed_amount', 'payment_amount', 'owed_amount_after_payment', 
                      'paymentProperty', 'purchase_amount', 'applied_amount', 'purchase_user', 'paymentType', 'payment_user', 'comments')
        #在审批中 并且是采购部门
        elif hasattr(self, 'org_obj') and self.org_obj and self.org_obj.is_applied and not paymentAuditStatus(self.org_obj, ITEM_REJECTED) and isGroup(self, PURCHASE_GROUP):
            result = ('company', 'vendor', 'content', 'owed_amount', 'payment_amount', 'owed_amount_after_payment', 
                      'paymentProperty', 'purchase_amount', 'applied_amount', 'purchase_user', 'paymentType', 'payment_user', 'comments')
        #在审批中 并且不是采购部门
        elif hasattr(self, 'org_obj') and self.org_obj and self.org_obj.is_applied and not paymentAuditStatus(self.org_obj, ITEM_REJECTED) and not isGroup(self, PURCHASE_GROUP):
            result = ('company', 'vendor', 'content', 'owed_amount', 'payment_amount', 'owed_amount_after_payment', 
                      'paymentProperty', 'purchase_amount', 'purchase_user', 'paymentType', 'payment_user', 'comments')
        
        return result
            
        
        
    show_bookmarks = False
    list_display = ('payment_id', 'company', 'vendor', 'content', 'payment_amount', 'getAppliedAmount', 'getStatus', 'getAuditList', 'is_closed', 'doAction')
    list_display_links = ('payment_id',)
    exclude = ('payment_id', 'payment_date', 'is_applied', 'create_time', 'is_closed' )
    aggregate_fields = {"payment_amount": "sum",}
    search_fields = ['payment_id']
    list_filter = ['company__name', 'vendor__name', 'create_time']
    actions = [DeleteSelectedAction,]
    
    
    form_layout = (
       Fieldset(u'基本信息',
                     Row('company',), 
                     Row('vendor', 'content',), 
                     Row('payment_amount', 'applied_amount'),
                     Row('paymentType', 'payment_user')
                     ),
                    
       Fieldset(u'本产品采取月结采购方式',
                    Row('owed_amount', 'owed_amount_after_payment'),
                        'paymentProperty',
                    ), 
                    
                    
       Fieldset(u'本产品采取临时采购方式',
                     Row('purchase_amount', 'purchase_user')
                     ),  
                   
      Fieldset(u'其他',
                     Row('comments')
                     ),  
    )
    

class DoPayemntAdmin(object):
    
    
    def getPaymentId(self, instance):
        return "<a href='/payment/payment/%s/detail/'>%s</a>" % (instance.id,instance.payment_id)
    getPaymentId.short_description = u"付款单"
    getPaymentId.allow_tags = True
    getPaymentId.is_column = True
    
    def getRouteName(self, instance):
        return u'付款申请'
    getRouteName.short_description = u"所属流程"
    getRouteName.allow_tags = True
    getRouteName.is_column = True
    
    def getStatus(self, instance):
        return u'审批完成'
    getStatus.short_description = u"审批状态"
    getStatus.allow_tags = True
    getStatus.is_column = True
    
    def getPaymentAmount(self, instance):
        amount = instance.payment_amount
        if instance.applied_amount :
            amount = instance.applied_amount
        return amount
    getPaymentAmount.short_description = u"付款金额"
    getPaymentAmount.allow_tags = True
    getPaymentAmount.is_column = True
    
    def getVendorCategory(self, instance):
        return instance.vendor.category or ''
    getVendorCategory.short_description = u'供应商分类'
    getVendorCategory.allow_tags = True
    getVendorCategory.is_column = True
    
    def getAuditList(self, instance):
        return "<a href='/workflow/audit/%s/list/'><i class='fa fa-calendar'></i></a>" % instance.payment_id
    getAuditList.short_description = u"审核日志"
    getAuditList.allow_tags = True
    getAuditList.is_column = True
    
    def get_context(self):
        context = super(DoPayemntAdmin,self).get_context()
        context.update({
            'show_delete_link': False,
            'has_delete_permission': False,
            'has_change_permission': False,
            })
        context['has_add_permission']= ''
        return context
    
    def closePayment(self, instance):
        if not instance.is_closed:
            return "<button class='btn btn-success' type='submit'  name='_submit'  value='%s'/>闭合 </button>" % instance.payment_id
        else:
            return ''
    closePayment.short_description = u"操作"
    closePayment.allow_tags = True
    closePayment.is_column = True
    
    def export(self, instance):
        return "<a href='/payment/exportExcel/?id=%s'><i class='fa fa-cloud-download'></i></a>" % instance.id
    export.short_description = u"导出"
    export.allow_tags = True
    export.is_column = True
    
    def post_response(self, *args, **kwargs):
        order_id = self.request.POST.get('_submit')
        if order_id:
            self.message_user(u"闭合完成", 'success')
        else:
            return super(DoPayemntAdmin, self).post_response(*args, **kwargs)
        
    
    def post(self, request, *args, **kwargs):
        payment_id = request.POST.get('_submit')
        if payment_id:
            close_payment(payment_id)
            
        return super(DoPayemntAdmin, self).post(request, *args, **kwargs)
    
    def get_list_display(self):
        list_display = super(DoPayemntAdmin, self).get_list_display()
        
        #只有财务部门才能闭合
        if isGroup(self, ACCOUNT_GROUP_MANAGER) or isGroup(self, ACCOUNT_GROUP) :
            list_display.append('closePayment')
        return list_display
    
        
    def result_item(self, obj, field_name, row):
        item = super(DoPayemntAdmin, self).result_item(obj, field_name, row)
        if (field_name == 'payment_date' ) and obj.is_closed:
            item.btns = []
            
        return item
                
    model = Payment
    list_display = ('payment_id', 'company', 'getVendorCategory', 'vendor', 'getPaymentAmount', 'payment_date', 'paymentType', 'getStatus', 'getAuditList', 'is_closed', 'export')
    search_fields = ['payment_id']
    list_filter = ['company__name', 'vendor__name', 'create_time']
    list_editable = ['payment_date',]
        
    def queryset(self):
        queryset = QuerySet(Payment).none()
    
        items = Item.objects.filter(document__document_id__startswith = 'PT', status = ITEM_APPROVED).values('document__document_id')
        if len(items) > 0:
            queryset =  super(DoPayemntAdmin, self).queryset().filter(payment_id__in = items)
            
        return  queryset

xadmin.site.register(PaymentProperty, PaymentPropertyAdmin)
xadmin.site.register(PaymentType, PaymentTypeAdmin)    
xadmin.site.register(Payment, PaymentAdmin)  
xadmin.site.register(DoPayemnt, DoPayemntAdmin)  
# xadmin.site.register_view(r'^payment/order/$',PaymentOrder , name='payment/order')
xadmin.site.register_view(r"^payment/exportExcel/", ExportPaymentView, 'payment/exportExcel')