# coding=utf-8
from django.db.models import Q

from document.models import Document, DocumentLineItem
from order.models import Order, OrderLine, ReceivingLine
from vendor_account import combine_lines
import xlwt
import datetime
ezxf = xlwt.easyxf
from xlwt import *
from xplugin.excel.excel_util import write_details, getNewBorder, write_line, write_two_lines
from report.vendor_account import *


def get_project_receiving_list(start_date, end_date, project_name, vendor):
    
    args_list = [] 
    
    if start_date:
        args_list.append(Q(checkAccount__start_date__gte=start_date)) 
    if end_date:
        args_list.append(Q(checkAccount__end_date__lte=end_date))
    if project_name:
        args_list.append(Q(orderLine__order__project__name = project_name))
    
    if len(vendor) > 0:
        vendors = getVendorGroups(vendor)
        if len(vendors) > 0: 
            args_list.append(Q(orderLine__order__vendor__in=vendors))
        
    args_list.append(Q(checkAccount__isnull = False))
        
    args = Q() 
    for each_args in args_list :
        args = args & each_args
    
    receivingLines = ReceivingLine.objects.filter(*(args,)).order_by('receiving_date', 
                                                                     'orderLine__documentLineItem__projectMaterial__project__name',
                                                                     'orderLine__documentLineItem__projectMaterial__material__category__name',
                                                                     'orderLine__documentLineItem__projectMaterial__material__name',
                                                                     'orderLine__documentLineItem__projectMaterial__material__specification')
    details = combine_lines(receivingLines)    
    
    result = {}
    result['project_name'] = project_name
    result['vendor_name'] = vendor
    result['start_date'] = start_date
    result['end_date'] = end_date
    result['sum'] = details['sum']
    result['lines'] = details['lines']
    
    return result



def write_receiving_list(sheet, result, rowx):
    detail_head = [u'序号', u'材料名称', u'品牌', u'规格', u'单位', u'数量', u'单价', u'金额', u'送货日期', u'送货单位', u'备注']
    head_width =  [0x0d00,   5000,   5000, 5000,  0x0d00,  0x0d00,  0x0d00, 0x0d00,  4000,   8000,  8000]
    merge_col =   [1,         1,          1,    1,       1,     1,         1,     1,       1,      1,  1]
    kinds =       'int       text      text    text    text     int     price   money     date    text    text'.split()
    style =       [ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'), 
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left')]

    heading_xf = {'style' : style,
                   'width' : head_width,
                   'merge_col' : merge_col}
    data_format = 'font: height 240; align: wrap on, vert centre, horiz left'
    number_format = 'font: height 240; align: wrap on, vert centre, horiz right'
    kind_to_xf_map = {
            'date': ezxf(data_format ,num_format_str='yyyy-mm-dd'),
            'int': ezxf(number_format, num_format_str='#,##0'),
            'money': ezxf(number_format ,num_format_str='#,##0.00'),
            'price': ezxf(number_format,num_format_str='#0.00'),
            'text': ezxf(data_format),
            }
    data_xfs = [kind_to_xf_map[k] for k in kinds]
    
    data = []
    index = 1
    for line in result['lines']:
        row = []
        row.append(index)
        row.append(line['projectMaterialName'])
        row.append(line['brand'])
        row.append(line['specification'])
        row.append(line['unit'])
        row.append(line['receiving_quantity'])
        row.append(line['price'])
        row.append(line['totalPrice'])
        row.append(line['receiving_date'])
        row.append(line['vendor'])
        row.append(line['comments'] or '')
        data.append(row)
        index = index + 1
    
    write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs) 
    
def generate_project_receiving_list(result):
    column = 10
    book = xlwt.Workbook(encoding='utf-8')
    sheet = book.add_sheet("receiving_detail")
    report_title = u'到货单'
    report_title_xf = ezxf('font: bold on, height 400; align: wrap on, vert centre, horiz center') 
    sheet.write_merge(0, 2, 0, column, report_title, report_title_xf)
    
    write_two_lines(sheet, 3, column)
    data_format = 'font: height 240; align: wrap on, vert centre, horiz left'
    report_subtitle_xf = ezxf(data_format)
    
    report_subtitle = u'项目名称：' + result['project_name']
    sheet.write_merge(4, 5, 0, 6, report_subtitle, report_subtitle_xf)
    
    report_subtitle = u'日期：' + result['start_date'] + '  -  ' + result['end_date']
    sheet.write_merge(4, 5, 7, column, report_subtitle, report_subtitle_xf)
    
    write_line(sheet, 6, column)
    
    write_receiving_list(sheet, result, 7)
    
    rowx = 7 + len(result['lines']) + 1
    write_line(sheet, rowx, column)
    
    report_subtitle = u'合计'
    report_subtitle_xf = ezxf('font: height 240; align: wrap on, vert centre, horiz center')
    
    rowx = rowx+1
    sheet.write_merge(rowx, rowx+1, 0, 6, report_subtitle, report_subtitle_xf)
    
    data_format = 'font: height 240; align: wrap on, vert centre, horiz right'
    report_subtitle_xf = ezxf(data_format, num_format_str='#,##0.00')
    sheet.write_merge(rowx, rowx+1, 7, 7, result['sum'], report_subtitle_xf)
    
    rowx = rowx+2
    write_line(sheet, rowx, column)
    
    rowx = rowx+1
    report_subtitle = u'项目经理确认：'
    data_format = 'font: height 240; align: wrap on, vert centre, horiz left'
    report_subtitle_xf = ezxf(data_format)
    sheet.write_merge(rowx, rowx + 1, 0, column, report_subtitle, report_subtitle_xf)
    
    return book
    