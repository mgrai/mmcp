# coding=utf-8
import xlwt
import StringIO
import datetime
from django.http import HttpResponse
from django.utils.encoding import force_unicode, smart_unicode 
from xadmin.views.base import CommAdminView
from django.utils.translation import ugettext_lazy as _
from report.purchaseOrder import generate_order


class ExportExcelView(CommAdminView):
    
    def get(self, request, *args, **kwargs):
        file_type = 'xls'
        file_name = 'order'
        response = HttpResponse(mimetype="%s; charset=UTF-8" % 'application/vnd.ms-excel')
        response['Content-Disposition'] = ('attachment; filename=%s.%s' % (file_name, file_type)).encode('utf-8')
        
        context = super(ExportExcelView, self).get_context()
        context['order_id'] = self.request.GET['order_id']
        response.write(getattr(self, 'get_xls_export')(context))
        return response
    
    def get_xls_export(self, context):
        output = StringIO.StringIO()
        order_id = context['order_id']
        book = generate_order(order_id)   
        book.save(output)
        output.seek(0)
        return output.getvalue()
    
 
