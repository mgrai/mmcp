# coding=utf-8
from order.models import Order, OrderLine, ReceivingLine, Invoice
from document.models import Document, DocumentLineItem
from payment.models import Payment
from django.db.models import Q, Sum
from django.http import HttpResponse
from django.db import connection
from report.vendor_account import dictfetchall
from decimal import *
import xlwt
import datetime
ezxf = xlwt.easyxf
from xlwt import *
from xplugin.excel.excel_util import write_details, getNewBorder, write_line, write_two_lines

def build_query(year, company):
    ##for mysql
    query = """SELECT company.name AS company_name, 
       project.name AS project_name, 
       project.material_amount AS estimate_total,
        
      IFNULL(setting.before_2015_amount,0) as 'before_current_year_amount',
      
      (case when 2015 = {0}  then project.one_month_amount
               when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='01' then sum( receiving.total) else 0 end) as 'one_month',
           
      (case when 2015 = {0}  then project.two_month_amount
               when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='02' then sum(receiving.total) else 0 end) as 'two_month',
      
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='03' then receiving.total else 0 end) as 'three_month',
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='04' then receiving.total else 0 end) as 'four_month',
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='05' then receiving.total else 0 end) as 'five_month',
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='06' then receiving.total else 0 end) as 'six_month',
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='07' then receiving.total else 0 end) as 'seven_month',
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='08' then receiving.total else 0 end) as 'eight_month',
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='09' then receiving.total else 0 end) as 'night_month',
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='10' then receiving.total else 0 end) as 'ten_month',
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='11' then receiving.total else 0 end) as 'eleven_month',
      sum(case when YEAR(checkaccount.end_date) = {0} and MONTH(checkaccount.end_date)='12' then receiving.total else 0 end) as 'twelve_month'
            
        FROM project_project project
        LEFT JOIN setting_projectsetting setting ON
        project.id = setting.project_id
        LEFT JOIN project_company company ON
        project.company_id = company.id
        LEFT JOIN order_order orders ON
        project.id = orders.project_id
        LEFT JOIN order_orderline orderline ON
        orders.id = orderline.order_id
        LEFT JOIN order_receivingline receiving ON
        orderline.id = receiving.orderLine_id
        LEFT JOIN order_checkaccount checkaccount ON
        receiving.checkAccount_id = checkaccount.id
        AND YEAR(checkaccount.end_date)<= '{0}'
        AND receiving.checkAccount_id is not null
        
        """.format(year)
         
    if len(company)>0:
            query += " WHERE company.name = '%s'" % company
        
    query += " GROUP BY company.id, project.id ORDER BY project.id DESC"
    return query
    
def get_project_used_list(year, company):
    query = build_query(year, company)
    
    rows= []
    c = connection.cursor()
    try:
        c.execute(query)
        rows = dictfetchall(c)
    finally:
        c.close()
    
    sum_line = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
   
    index = 0
    for line in rows:
        index += 1
        line['index'] = index
        sum_line[0] += (line['before_current_year_amount'] or 0)
        sum_line[1] += line['one_month'] or 0
        sum_line[2] += line['two_month'] or 0
        sum_line[3] += line['three_month']
        sum_line[4] += line['four_month']
        sum_line[5] += line['five_month']
        sum_line[6] += line['six_month']
        sum_line[7] += line['seven_month']
        sum_line[8] += line['eight_month']
        sum_line[9] += line['night_month']
        sum_line[10] += line['ten_month']
        sum_line[11] += line['eleven_month']
        sum_line[12] += line['twelve_month']
        
        line['total'] = (line['before_current_year_amount'] or 0) + (line['one_month'] or 0) + (line['two_month'] or 0)+  \
                        line['three_month'] + line['four_month'] + line['five_month'] + line['six_month'] +  \
                        line['seven_month'] + line['eight_month'] + line['night_month'] + line['ten_month'] + \
                        line['eleven_month'] + line['twelve_month']
        
        percent = line['total']/line['estimate_total'] * Decimal(100.0) if line['total'] != 0 and line['estimate_total'] != 0 and line['estimate_total'] is not None else 0.00
        
        line['percent'] = ("%.2f" % percent)
        sum_line[13] += (line['total'] or 0)
        
        
        
    result = {}
    result['lines'] = rows
    if len(rows) > 0:
        result['sum_line'] = sum_line
    
    result['year'] = year
    result['company'] = company
    return result


def write_project_used_list(sheet, result, rowx):
    detail_head = [u'序号', u'工程名称', u'预算成本',   u'本年之前已用量',  u'1月', u'2月', u'3月', u'4月', u'5月', u'6月', u'7月', u'8月', u'9月', u'10月', u'11月', u'12月', u'合计', u'用量百分比']
    head_width =  [0x0d00,   0x0d00,  5000,  5000,  4000, 4000,  4000,   4000,   4000, 4000,  4000,   4000, 4000, 4000,  4000,   4000,   5000,   4000,]
    merge_col =   [1,         1,          1,       1,     1,         1,     1,       1,      1,   1,   1,   1,   1,      1,  1,  1,  1,  1]
    kinds =       'int       text      price    price     price     price   price   price    price  price  price  price   price   price    price  price  price  price'.split()
    style=        [ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz left'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right')
                   ]
    
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
    for line in result['lines']:
            row = []
            row.append(line['index'])
            row.append(line['project_name'])
            row.append(line['estimate_total'])
            row.append(line['before_current_year_amount'])
            row.append(line['one_month'])
            row.append(line['two_month'])
            row.append(line['three_month'])
            row.append(line['four_month'])
            row.append(line['five_month'])
            row.append(line['six_month'])
            row.append(line['seven_month'])
            row.append(line['eight_month'])
            row.append(line['night_month'])
            row.append(line['ten_month'])
            row.append(line['eleven_month'])
            row.append(line['twelve_month'])
            row.append(line['total'])
            percent = str(line['percent']) + '%' 
            row.append(percent)
            data.append(row)
    
    write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs)
        
def generate_project_used_list(result):
    book = xlwt.Workbook(encoding='utf-8')
    sheet = book.add_sheet("project_used")
    report_title = str(result['year']) + '年消防在建工程材料表' 
    report_title_xf = ezxf('font: bold on, height 400; align: wrap on, vert centre, horiz center') 
    
    sheet.write_merge(0, 2, 0, 17, report_title, report_title_xf)
    
    write_two_lines(sheet, 3, 17)
    
    
    write_project_used_list(sheet, result, 4)
    
    rowx = 4 + len(result['lines']) + 1
    write_line(sheet, rowx, 17)
    
    report_subtitle = u'合计'
    report_subtitle_xf = ezxf('font: height 240; align: wrap on, vert centre, horiz center')
    
    rowx = rowx+1
    sheet.write_merge(rowx, rowx+1, 0, 2, report_subtitle, report_subtitle_xf)
    
    data_format = 'font: height 240; align: wrap on, vert centre, horiz right'    
    report_subtitle_xf = ezxf(data_format, num_format_str='#,##0.00')
    
    #write 合计
    col = 3
    for data in result['sum_line']:
        sheet.write_merge(rowx, rowx+1, col, col, data, report_subtitle_xf)
        col += 1
        
    
    return book       
