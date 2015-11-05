# coding=utf-8
import xadmin
from xadmin.plugins.batch import BatchChangeAction
from xadmin.plugins.actions import DeleteSelectedAction
from xadmin.views.list import ResultRow
from models import Order, OrderLine, ReceivingLine, CheckAccount,Invoice, CheckAccountDetail
from export import ExportExcelView
from mmcp.util import is_Receivied, close_order, is_closed_by_order_id, is_closed, is_closed_by_order_line_id, isGroup, ACCOUNT_GROUP_MANAGER, ACCOUNT_GROUP
from mmcp.actions import OrderLineSelectedAction
from django.http import  HttpResponseRedirect
from django.db.models import Sum
from order_util import update_document_purch_status

class OrderAdmin(object):
    
    def get_context(self):
        context = super(OrderAdmin, self).get_context()
        context['has_add_permission']= ''
        return context
    
    def getOrderId(self, instance):
        return "<a href='/order/orderline/?_rel_order__id__exact=%s'>%s</a>" % (instance.id, instance.order_id)
    getOrderId.short_description = u"采购单"
    getOrderId.allow_tags = True
    getOrderId.is_column = True
    
    def getDocumentId(self, instance):
        return "<a href='/document/documentlineitem/?_q_=%s&close=%s'>%s</a>" % (instance.document.document_id, instance.order_id, instance.document.document_id)
    getDocumentId.short_description = u"项目申请单"
    getDocumentId.allow_tags = True
    getDocumentId.is_column = True
    
    def exportOrder(self, instance):
        return "<a href='/order/exportExcel/?order_id=%s'><i class='fa fa-cloud-download'></i></a>" % instance.order_id
    exportOrder.short_description = u"导出"
    exportOrder.allow_tags = True
    exportOrder.is_column = True
    
    def closeOrder(self, instance):
        if not instance.is_closed:
            path = self.request.get_full_path()
            if path.count('=') > 0:
                path += '&_submit=%s' % instance.order_id
            else:
                path += '?_submit=%s' % instance.order_id 
            return """
                   <div class="btn-group export">
                      <a class="dropdown-toggle btn btn-default btn-sm" data-toggle="dropdown" href="#">
                                                                                闭合 <span class="caret"></span>
                      </a>
                      <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                          <li><a href="%s"><i class="fa fa-check-square-o"></i> 确认</a></li>
                      </ul>
                    </div>
                   """ % path
        else:
            return "<i class='fa fa-check-circle text-success' alt='True'></i>"
    closeOrder.short_description = u"已闭合"
    closeOrder.allow_tags = True
    closeOrder.is_column = True
    
        
    def get(self, request, *args, **kwargs):
        order_id = request.GET.get('_submit')
        if order_id:
            if is_Receivied(order_id):
                close_order(order_id)
                self.message_user(u"闭合完成", 'success')
                path = self.request.get_full_path()
                if path.rfind('&') > 0:
                    path = path[0:path.rindex('&')]
                elif path.find('?') > 0:
                    path = path[0:path.find('?')]
                return HttpResponseRedirect(path)
            else:
                self.message_user(u"该采购单到货未完成，不能进行闭合操作。", 'error')
            
        return super(OrderAdmin, self).get(request, *args, **kwargs)
    
    #已闭合的order不能被删除
    def filter_queryset(self, queryset):
        queryset = queryset.exclude(is_closed = True)
        return queryset
        
    def delete_models(self, queryset):
        queryset = self.filter_queryset(queryset)
        if len(queryset) > 0:
            document = queryset[0].document
            super(OrderAdmin, self).delete_models(queryset)
            update_document_purch_status(document)
        
            
    def result_item(self, obj, field_name, row):
        item = super(OrderAdmin, self).result_item(obj, field_name, row)
        if (field_name == 'vendor' or field_name == 'note') and obj.is_closed:
            item.btns = []
            
        return item
    
    def queryset(self):
        return super(OrderAdmin, self).queryset().filter(company = self.user.company)
   
    
    hidden_menu = True
    use_related_menu = False
    list_display = ('getOrderId', 'getDocumentId','project', 'vendor', 'note', 'user', 'exportOrder', 'closeOrder')
    list_display_links = ('none',)
    list_filter = ['vendor__name', 'project__name', 'create_time']
    list_editable = ['vendor', 'note']
    actions = [DeleteSelectedAction,]
    search_fields = ['project__name', 'order_id', 'document__document_id', 'vendor__name', 'user__username']


class OrderLineAdmin(object):
    
    #已闭合的order不能再增加新的order line
    def get_context(self):
        context = super(OrderLineAdmin, self).get_context()
        context['has_add_permission']= ''
#         if is_closed_by_order_id(self):
#             context['has_add_permission']= ''
        return context
    
        
    #已闭合的orderline不能被删除
    def filter_queryset(self, queryset):
        queryset = queryset.exclude(order__is_closed = True)
        return queryset
        
    def delete_models(self, queryset):
        queryset = self.filter_queryset(queryset)
        if len(queryset) > 0:
            document = queryset[0].documentLineItem.document
            super(OrderLineAdmin, self).delete_models(queryset)
            update_document_purch_status(document)
    
    #已闭全的order不能修改price,也不能增加到货明细  
    def result_item(self, obj, field_name, row):
        if 'related_link' == field_name and obj.order.is_closed:
            item = None
        else:
            item = super(OrderLineAdmin, self).result_item(obj, field_name, row)
            if (field_name == 'price' or field_name == 'purchase_quantity' ) and obj.order.is_closed:
                item.btns = []
            
        return item
    
    def block_results_bottom_action(self, context, nodes):
        if '_rel_order__id__exact' in self.params and self.params['_rel_order__id__exact']:
            order_id = self.params['_rel_order__id__exact']
            order = Order.objects.get(id=order_id)
            url = '/order/order/?_q_=%s' % order.order_id
            return "<a class='dropdown-toggle navbar-right btn btn-success'  href='%s'>下一步</a>" % url
            
    
    def getOrderId(self, instance):
        return "<a href='/order/receivingline/?_rel_orderLine__id__exact=%s'>%s</a>" % (instance.id, instance.order.order_id)
    getOrderId.short_description = u"采购单"
    getOrderId.allow_tags = True
    getOrderId.is_column = True
    
    def get_model_form(self, **kwargs):
        form = super(OrderLineAdmin, self).get_model_form(**kwargs)
        if "_rel_order__id__exact" in self.request.GET:
            order_id = self.request.GET['_rel_order__id__exact']
            #过滤采购单名细
            order = form.base_fields['order'].queryset.filter(id=order_id)
            form.base_fields['order'].queryset = order
            #过滤项目材料
            form.base_fields['documentLineItem'].queryset = form.base_fields['documentLineItem'].queryset.filter(document__document_id=order[0].document.document_id)
            
        return form
    
    @property
    def list_editable(self):
        list_editable = ['brand','expected_date','purchase_quantity','price']
        if is_closed_by_order_id(self):
            list_editable = None
        return list_editable
    
    @property
    def actions(self):
        actions = [OrderLineSelectedAction, BatchChangeAction,]
        #闭合的采购单不能再被修改
        if is_closed_by_order_id(self):
            actions = None
        return  actions
    
    def queryset(self):
        return super(OrderLineAdmin, self).queryset().filter(order__company = self.user.company)
    
    
    use_related_menu = False
    hidden_menu = True
    list_display = ['getOrderId', 'getProjectName', 'getProjectMaterial',  'brand', 'getQuantity', 'getExpectedQuantity', 'getAuditQuantity', 'getTotalPurchasedQuantity', 'expected_date','purchase_quantity','getPostedQuantity', 'price', 'total',  'getComments']
    list_display_links = ('documentLineItem',)
    aggregate_fields = {"total": "sum",}
    batch_fields = ('expected_date', 'brand') 
    search_fields = ['order__order_id', 'order__project__name', 'order__vendor__name']
    list_filter = ['order__project__name', 'order__vendor__name']
    

class ReceivingLineAdmin(object):
    #已闭合的order不能修改    到货数量  和 到货日期   
    def result_item(self, obj, field_name, row):
        item = super(ReceivingLineAdmin, self).result_item(obj, field_name, row)
        if (field_name == 'receiving_quantity' or field_name == 'receiving_date' or field_name == 'comments') and obj.orderLine.order.is_closed:
            item.btns = []
        return item
    
    #已闭合的order不能加修改 link  
    def get_list_display_links(self):
        list_display_links = super(ReceivingLineAdmin, self).get_list_display_links()
        if "_q_" in self.request.GET:
            order_id = self.request.GET['_q_']
            if is_closed(order_id):
                list_display_links = ('none')
        
        if is_closed_by_order_line_id(self):
                list_display_links = ('none')
        return list_display_links
    
    #已闭合的order去掉增加button
    def get_context(self):
        context = super(ReceivingLineAdmin, self).get_context()
        context['has_add_permission']= ''
#         if "_q_" in self.request.GET:
#             order_id = self.request.GET['_q_']
#             if is_closed(order_id):
#                 context['has_add_permission']= ''
#                 
#         if is_closed_by_order_line_id(self):
#             context['has_add_permission']= ''
            
        return context
    
    #已闭合的order不能被删除
    def filter_queryset(self, queryset):
        queryset = queryset.exclude(orderLine__order__is_closed = True)
        return queryset
        
    def delete_models(self, queryset):
        queryset = self.filter_queryset(queryset)
        if len(queryset) > 0:
            for line in queryset:
                line.orderLine.documentLineItem.posted_quantity -= (line.receiving_quantity or 0)
                line.orderLine.documentLineItem.save(update_fields=['posted_quantity'])
            super(ReceivingLineAdmin, self).delete_models(queryset)
    
    def get_model_form(self, **kwargs):
        form = super(ReceivingLineAdmin, self).get_model_form(**kwargs)
        if "_rel_orderLine__id__exact" in self.request.GET:
            order_line_id = self.request.GET['_rel_orderLine__id__exact']
            #过滤采购单名细
            form.base_fields['orderLine'].queryset = form.base_fields['orderLine'].queryset.filter(id=order_line_id)
            
        if "_rel_orderLine__order__id__exact" in self.request.GET:
            order_id = self.request.GET['_rel_orderLine__order__id__exact']
            #过滤采购单名细
            form.base_fields['orderLine'].queryset = form.base_fields['orderLine'].queryset.filter(order__id=order_id)
        
        if 'update' in self.request.get_full_path():
            receivingLine_id = self.request.get_full_path().split('/')[3]
            receivingLine = ReceivingLine.objects.get(id = receivingLine_id)
            #过滤采购单名细
            form.base_fields['orderLine'].queryset = form.base_fields['orderLine'].queryset.filter(id=receivingLine.orderLine.id)
            
            
        return form
    
    @property
    def actions(self):
        #闭合的采购单不能再被修改
        actions = [DeleteSelectedAction, BatchChangeAction]
        if "_q_" in self.request.GET:
            order_id = self.request.GET['_q_']
            if is_closed(order_id):
                actions = None
        if is_closed_by_order_line_id(self):
            actions = None
        
        return  actions
    
    def queryset(self):
        return super(ReceivingLineAdmin, self).queryset().filter(orderLine__order__company = self.user.company)
    
    
    list_display = ('getOrderId', 'getProjectName','getProjectMaterialName', 'getPurchaseQuantity', 'receiving_quantity', 'receiving_date', 'getPrice', 'comments')
    list_editable = ['receiving_quantity', 'receiving_date', 'comments']
    list_filter = ['receiving_date', 'orderLine__order__project__name', 'orderLine__order__vendor__name']
    aggregate_fields = {"total": "sum",}
    exclude = ['total','checkAccount', 'original_receiving_quantity']
    batch_fields = ('receiving_date',) 
    search_fields = ['orderLine__order__order_id', 'orderLine__order__project__name', 
                     'orderLine__documentLineItem__projectMaterial__material__name',
                     'orderLine__documentLineItem__material',
                     'orderLine__order__vendor__name',
                     'orderLine__documentLineItem__projectMaterial__material__specification']
    
    
class CheckAccountAdmin(object):
    
    def exportExcel(self, instance):
        return "<a href='/report/vendor/account/export?check_account_id=%s'><i class='fa fa-cloud-download'></i></a>" % instance.check_account_id
    exportExcel.short_description = u"导出"
    exportExcel.allow_tags = True
    exportExcel.is_column = True
    
    def delete_models(self, queryset):
        #删除对帐单后要更新采购单 闭合的状态
        for line in queryset:
            receivings = ReceivingLine.objects.filter(checkAccount = line)
            for receiving in receivings:
                receiving.orderLine.order.is_closed = False
                receiving.orderLine.order.save(update_fields=['is_closed'])
        super(CheckAccountAdmin, self).delete_models(queryset)
        
    def queryset(self):
        return super(CheckAccountAdmin, self).queryset().filter(company = self.user.company)
    
    
    use_related_menu = False
    list_display = ('vendor','check_account_id', 'create_time', 'exportExcel')
    list_display_links = ('none',)
    search_fields = ['check_account_id',]
    list_filter = ['create_time', 'vendor__name']
    actions = [DeleteSelectedAction,]
    
class InvoiceAdmin(object):
    
    def confirmReceived(self, instance):
        if not instance.is_received:
            path = self.request.get_full_path()
            if path.count('=') > 0:
                path += '&_submit=%s' % instance.id
            else:
                path += '?_submit=%s' % instance.id 
            
            #只有财务人员才能确认收票
            if  isGroup(self, ACCOUNT_GROUP_MANAGER) or isGroup(self, ACCOUNT_GROUP):
                    
                return """
                       <div class="btn-group export">
                          <a class="dropdown-toggle btn btn-default btn-sm" data-toggle="dropdown" href="#">
                                                                                    确认收票<span class="caret"></span>
                          </a>
                          <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                              <li><a href="%s"><i class="fa fa-check-square-o"></i> 确认</a></li>
                          </ul>
                        </div>
                       """ % path
            else:
                return " "
        else:
            return "<i class='fa fa-check-circle text-success' alt='True'> 已收票</i>"
    confirmReceived.short_description = u"操作"
    confirmReceived.allow_tags = True
    confirmReceived.is_column = True
    
    def confirm_receive_invoice(self, invoice_id):
        invoice = None
        try:     
            invoice = Invoice.objects.get(id=invoice_id)
        except Invoice.DoesNotExist:
            pass
        
        if invoice:
            invoice.is_received = True
            invoice.save(update_fields=['is_received'])
        
    
    def get(self, request, *args, **kwargs):
        invoice_id = request.GET.get('_submit')
        if invoice_id:
            self.confirm_receive_invoice(invoice_id)
            self.message_user(u"确认收票完成", 'success')
        return super(InvoiceAdmin, self).get(request, *args, **kwargs)
    
    @property
    def exclude(self):
        #新增的时候不需要输入收票日期，财务确认收票时候再输入
        return ['receive_date', 'is_received'] 
    
    @property
    def list_editable(self):
        if  isGroup(self, ACCOUNT_GROUP_MANAGER) or isGroup(self, ACCOUNT_GROUP):  
            return ['receive_date',]    
        
    def queryset(self):
        return super(InvoiceAdmin, self).queryset().filter(company = self.user.company)
    
    
    list_display = ('invoice_number', 'company', 'invoice_type', 'amount',  'date', 'receive_date', 'user', 'vendor', 'checkAccounts', 'confirmReceived')
    list_display_links = ('invoice_number',)
    list_filter = ['company__name', 'vendor__name', 'date', 'receive_date']
    search_fields = ['invoice_number', 'vendor__name', 'company__name']
    style_fields = {'checkAccounts': 'm2m_dropdown',}
    aggregate_fields = {"amount": "sum",}
    actions = [DeleteSelectedAction,]
    
class CheckAccountDetailAdmin(object):
    use_related_menu = False
    
    def get_comments(self, instance):
        comments = instance.orderLine.documentLineItem.comments or ''
        if len(comments) > 0:
            comments += "    " + (instance.comments or '')
        return comments
    get_comments.short_description = u"备注"
    get_comments.allow_tags = True
    get_comments.is_column = True
    
    list_display = ('getCheckAccountId', 'getOrderId', 'getProjectName','getProjectMaterialName', 'getPurchaseQuantity', 'receiving_quantity', 'receiving_date', 'getPrice', 'get_comments')
    list_filter = ['checkAccount__create_time', 'orderLine__order__project__name', 'orderLine__order__vendor__name']
    search_fields = ['checkAccount__check_account_id', 'orderLine__order__project__name', 
                     'orderLine__order__vendor__name']
    global_actions = [] 
    
    def queryset(self):
        return super(CheckAccountDetailAdmin, self).queryset().filter(orderLine__order__company = self.user.company, checkAccount__isnull=False)   
        
xadmin.site.register(Order, OrderAdmin)      
xadmin.site.register(OrderLine, OrderLineAdmin) 
xadmin.site.register(ReceivingLine, ReceivingLineAdmin) 
xadmin.site.register(CheckAccount, CheckAccountAdmin) 
xadmin.site.register(Invoice, InvoiceAdmin)
xadmin.site.register(CheckAccountDetail, CheckAccountDetailAdmin)
xadmin.site.register_view(r"^order/exportExcel/", ExportExcelView, 'order/exportExcel') 