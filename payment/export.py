# coding=utf-8
import StringIO
import datetime
from django.http import HttpResponse
from django.utils.encoding import force_unicode, smart_unicode 
from xadmin.views.base import CommAdminView
from django.utils.translation import ugettext_lazy as _
from report.purchaseOrder import generate_order
from .models import Payment
from workflow.models import TaskHistory, AUDIT_HISTORY_STATUS
import xlwt
ezxf = xlwt.easyxf
from xlwt import *
from xplugin.excel.excel_util import write_details, getNewBorder, write_line, write_two_lines
from report.report_util import to_rmb_upper


class ExportPaymentView(CommAdminView):
    
    def get(self, request, *args, **kwargs):
        file_type = 'xls'
        file_name = 'payment'
        response = HttpResponse(mimetype="%s; charset=UTF-8" % 'application/vnd.ms-excel')
        response['Content-Disposition'] = ('attachment; filename=%s.%s' % (file_name, file_type)).encode('utf-8')
        
        context = super(ExportPaymentView, self).get_context()
        context['payment_id'] = self.request.GET['id']
        response.write(getattr(self, 'get_xls_export')(context))
        return response
    
    def get_xls_export(self, context):
        output = StringIO.StringIO()
        payment_id = context['payment_id']
        book = self.generate_payment(payment_id)   
        book.save(output)
        output.seek(0)
        return output.getvalue()
    
    def generate_payment(self, payment_id):
        payment = Payment.objects.get(id = payment_id)
        
        
        if payment:
            book = xlwt.Workbook(encoding='utf-8')
            sheet = book.add_sheet("payment")
            max_column = 3
            
            rowx = 0
            report_subtitle = u'付款单'
            report_title_xf = ezxf('font: bold on, height 400; align: wrap on, vert centre, horiz center') 
            sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_title_xf) 
            
            rowx += 2
            write_two_lines(sheet, rowx, max_column)
            
            rowx += 1
            
            report_subtitle_xf = ezxf('font: height 240; align: wrap on, vert centre, horiz left')
            
            report_subtitle = u'公司: ' + payment.company.name
            sheet.write_merge(rowx, rowx+1, 0, 1, report_subtitle, report_subtitle_xf)
            
            report_subtitle = u'付款单号: ' + payment.payment_id
            sheet.write_merge(rowx, rowx+1, 2, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            write_line(sheet, rowx, max_column)
            
            rowx += 1
            report_subtitle = u'供应商: ' + payment.vendor.name
            sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            
            applied_amount = payment.applied_amount
            report_subtitle = u'本次付款金额: ' + str(applied_amount) + "    "
            
            # 加上 大写金额
            if applied_amount > 0:
                report_subtitle += "( " + to_rmb_upper(applied_amount) + " )"
            else:
                report_subtitle += "( " + '负' + to_rmb_upper(applied_amount * -1) + " )"
                
            sheet.write_merge(rowx, rowx+1, 0, 1, report_subtitle, report_subtitle_xf)
            
            report_subtitle = u'采购物资内容: ' + payment.content
            sheet.write_merge(rowx, rowx+1, 2, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            
            report_subtitle = u'付款方式: ' + payment.paymentType.name
            sheet.write_merge(rowx, rowx+1, 0, 1, report_subtitle, report_subtitle_xf)
            
            report_subtitle = u'付款经办人: ' + str(payment.payment_user)
            sheet.write_merge(rowx, rowx+1, 2, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            write_line(sheet, rowx, max_column)
            
            rowx += 1
            
            report_subtitle_xf = ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left')
            report_subtitle = u'本产品采取月结采购方式' 
            sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            write_line(sheet, rowx, max_column)
            
            rowx += 1
            report_subtitle_xf = ezxf('font: height 240; align: wrap on, vert centre, horiz left')
            report_subtitle = u'现欠款额: ' + str(payment.owed_amount)
            sheet.write_merge(rowx, rowx+1, 0, 1, report_subtitle, report_subtitle_xf)
            
            report_subtitle = u'本期支付后欠款额: ' + str(payment.owed_amount_after_payment)
            sheet.write_merge(rowx, rowx+1, 2, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            report_subtitle = u'款项属性: ' + payment.paymentProperty.name
            sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            write_line(sheet, rowx, max_column)
            
            rowx += 1
            report_subtitle_xf = ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left')
            report_subtitle = u'本产品采取临时采购方式' 
            sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            write_line(sheet, rowx, max_column)
            
            rowx += 1
            report_subtitle_xf = ezxf('font: height 240; align: wrap on, vert centre, horiz left')
            report_subtitle = u'采购金额: ' + (str(payment.purchase_amount) if payment.purchase_amount else '')
            sheet.write_merge(rowx, rowx+1, 0,1, report_subtitle, report_subtitle_xf)
            
            report_subtitle = u'采购经手人: ' + (str(payment.purchase_user) if payment.purchase_user else '')
            sheet.write_merge(rowx, rowx+1, 2, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            write_line(sheet, rowx, max_column)
            
            rowx += 1
            
            report_subtitle = u'备注:     ' + (payment.comments if payment.comments else '')
            sheet.write_merge(rowx, rowx+2, 0, max_column, report_subtitle, report_subtitle_xf)
            rowx += 3
            write_line(sheet, rowx, max_column)
            
            rowx += 1
            report_subtitle_xf = ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left')
            report_subtitle = u'审批流程' 
            sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
            
            rowx += 2
            write_line(sheet, rowx, max_column)
            
            rowx += 1
            
            
            data = []
            histories = TaskHistory.objects.filter(item__document__document_id=payment.payment_id)
            for history in histories:
                row = []
                row.append(history.actor.actor_name if history.actor else '')
                row.append(AUDIT_HISTORY_STATUS[history.status][1])
                row.append(str(history.user))
                row.append(history.create_date.strftime("%Y-%m-%d %H:%M:%S"))
                data.append(row)
                
            write_histories(sheet, data, rowx)
            
            
            return book
            
            
def write_histories(sheet, data, rowx):
    detail_head = [u'步骤', u'意见', '审批人', '审批时间']
    head_width =  [8000,       8000,     8000,  8000]
    merge_col =   [1,            1,       1,      1]
    kinds =       'text      text      text      text'
    style=        [ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz left')]
    
    kinds = kinds.split()
    heading_xf = {'style' : style,
                   'width' : head_width,
                   'merge_col' : merge_col}
    data_format = 'font: height 240; align: wrap on, vert centre, horiz left'
    kind_to_xf_map = {
            'date': ezxf(data_format ,num_format_str='yyyy-mm-dd'),
            'int': ezxf(data_format, num_format_str='#,##0'),
            'money': ezxf(data_format ,num_format_str='#,##0.00'),
            'price': ezxf(data_format,num_format_str='#0.00'),
            'text': ezxf(data_format),
            }
    data_xfs = [kind_to_xf_map[k] for k in kinds]
    
    write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs)
    