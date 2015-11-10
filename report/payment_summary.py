# coding=utf-8
# from datetime import date
import xlwt
import datetime
ezxf = xlwt.easyxf
from xlwt import *
from django.db.models import Count
from xplugin.excel.excel_util import write_details, getNewBorder, write_line, write_two_lines
from vendor_account import *
from material.models import Vendor
from project.models import Company
from mmcp.util import *
from order.models import *


def get_check_account_vendors(self):
    company_ids = getAllCompanyIds(self)
    vendors = CheckAccount.objects.filter(company__id__in = company_ids).values('vendor__id').annotate(vendor_count=Count('vendor__id'))
    
    ids = []
    for vendor in vendors:
        ids.append(vendor['vendor__id'])
        
    return Vendor.objects.filter(id__in = ids).order_by('category__id', 'tree_id', 'lft')
    
def get_payment_summary(self, year, month):
    
    start_date = get_first_date_of_month(year, month)
    end_date = get_last_date_of_month(year, month)
    vendors = get_check_account_vendors(self)
    
    companies = getAllCompany(self)
    
    rows = []
    index = 0
    totals = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        
    for vendor in vendors:
            subtotals = [0, 0, 0, 0, 0, 0, 0, 0, 0]
            has_data = False
            for company in companies:
                row = {}
                #前一年底欠款
                owed_amount_before_year = getOwedAmountByYear((year - 1), 12, vendor, company)
                
                #前一年底欠发票
                owed_invoice_before_year = getOwedInvoiceByYear((year -1), 12, vendor, company)
                
                #2015年发生额(本年当月底已收货金额)
                receiving_total = getTotalReceivingByMonth(year, month, vendor, company) 
                    
                #本年 当月底已欠票（未开发票）
                unreceiving_invoice = getOwedInvoiceByYear(year, month, vendor, company)
                
                #本年 前一个月底已欠款
                owed_amount_before_month = getOwedAmountByYear(year, (month - 1), vendor, company)
                
                #当月送货        
                receivings = get_last_term_receiving_lines(start_date, end_date, vendor, company)
                row['month_receiving'] = receivings['sum']
                
                #当月付款
                payments = get_payment_details(start_date, end_date, vendor, company)
                row['month_payment'] = payments['payments_sum']
                
                #(实际应付款)截止到本月底已欠款 = 上个月底欠款 + 本月送货 - 本月付款
                owed_amount = owed_amount_before_month + receivings['sum'] - payments['payments_sum']
                
                #当月开票
                invoices = get_invoices(start_date, end_date, vendor, company)
                row['month_invoice'] = invoices['invoices_sum']
                
                row['owed_amount_before_year'] = owed_amount_before_year
                row['owed_invoice_before_year'] = owed_invoice_before_year
                row['receiving_total'] = receiving_total
                row['unreceiving_invoice'] = unreceiving_invoice
                row['owed_amount_before_month'] = owed_amount_before_month
                row['owed_amount'] = owed_amount
                
                #只有大于零才显示
                if row['owed_amount_before_year'] != 0 or row['owed_invoice_before_year'] != 0 or row['receiving_total'] != 0 or \
                   row['unreceiving_invoice'] != 0 or row['owed_amount_before_month'] != 0 or row['owed_amount'] != 0 or \
                   row['month_receiving'] != 0 or row['month_invoice'] or row['month_payment'] != 0:
                    
                    rows.append(row)
                    index += 1
                    row['index'] = index
                    row['vendor_category'] = vendor.category
                    row['vendor'] = vendor
                    row['company'] = company.short_name
                    
                    subtotals[0] += row['owed_amount_before_year']
                    subtotals[1] += row['owed_invoice_before_year']
                    subtotals[2] += row['receiving_total']
                    subtotals[3] += row['unreceiving_invoice']
                    subtotals[4] += row['owed_amount_before_month']
                    subtotals[5] += row['owed_amount']
                    subtotals[6] += row['month_receiving']
                    subtotals[7] += row['month_invoice']
                    subtotals[8] += row['month_payment']
                    
                    has_data = True
                    
            if has_data:
                row = {}
                row['index'] = -1
                row['vendor_category'] = vendor.category
                row['vendor'] = vendor
                row['company'] = ''
                row['owed_amount_before_year'] = subtotals[0]
                row['owed_invoice_before_year'] = subtotals[1]
                row['receiving_total'] = subtotals[2]
                row['unreceiving_invoice'] = subtotals[3]
                row['owed_amount_before_month'] = subtotals[4]
                row['owed_amount'] = subtotals[5]
                row['month_receiving'] = subtotals[6]
                row['month_invoice'] = subtotals[7]
                row['month_payment']= subtotals[8]
                rows.append(row)
                    
                    
                    
                totals[0] += subtotals[0]
                totals[1] += subtotals[1]
                totals[2] += subtotals[2]
                totals[3] += subtotals[3]
                totals[4] += subtotals[4]
                totals[5] += subtotals[5]
                totals[6] += subtotals[6]
                totals[7] += subtotals[7]
                totals[8] += subtotals[8]
        
    #供应商子公司统计
    parent_vendors = getAllParentVendor(self)
    parent_rows = []
    for parent_vendor in parent_vendors:
        new_row = {}
        new_row['index'] = -2
        new_row['vendor_category'] = parent_vendor.category
        new_row['vendor'] = parent_vendor
        new_row['company'] = ''
        new_row['owed_amount_before_year'] = 0
        new_row['owed_invoice_before_year'] = 0
        new_row['receiving_total'] = 0
        new_row['unreceiving_invoice'] = 0
        new_row['owed_amount_before_month'] = 0
        new_row['owed_amount'] = 0
        new_row['month_receiving'] = 0
        new_row['month_invoice'] = 0
        new_row['month_payment']= 0
        
        for myIndex,row in enumerate(rows):
            #只取总计
            if row['index'] == -1:
                
                vendor = row['vendor']
                
                if vendor.parent == parent_vendor or vendor == parent_vendor :
                    new_row['owed_amount_before_year'] += row['owed_amount_before_year']
                    new_row['owed_invoice_before_year'] += row['owed_invoice_before_year']
                    new_row['receiving_total'] += row['receiving_total']
                    new_row['unreceiving_invoice'] += row['unreceiving_invoice']
                    new_row['owed_amount_before_month'] += row['owed_amount_before_month']
                    new_row['owed_amount'] += row['owed_amount']
                    new_row['month_receiving'] += row['month_receiving']
                    new_row['month_invoice'] += row['month_invoice']
                    new_row['month_payment'] += row['month_payment']
                    
                    #记录最后一条子供应商的位置
                    new_row['parent_index'] = myIndex
                    
        
        #只有大于零才显示
        if new_row['owed_amount_before_year'] != 0 or new_row['owed_invoice_before_year'] != 0 or new_row['receiving_total'] != 0 or \
           new_row['unreceiving_invoice'] != 0 or new_row['owed_amount_before_month'] != 0 or new_row['owed_amount'] != 0 or \
           new_row['month_receiving'] != 0 or new_row['month_invoice'] or new_row['month_payment'] != 0: 
            parent_rows.append(new_row)
#             print(new_row['vendor'].name + "             2014年底欠款"+ str(new_row['owed_amount_before_year'])) \
#                     +"        2014年底欠发票"+ str(new_row['owed_invoice_before_year']) \
#                     +"       2015年发生额" + str(new_row['receiving_total'])\
#                     +"       实际未开发票" + str(new_row['unreceiving_invoice'])\
#                     +"  截止2015年2月底欠款"+ str(new_row['owed_amount_before_month'])\
#                     +"  实际应付款"+ str(new_row['owed_amount'])\
#                     +"  送货"+ str(new_row['month_receiving'])\
#                     +"  开票"+ str(new_row['month_invoice'])\
#                     +"  付款"+ str(new_row['month_payment'])\
#                     +"   parent_index"+ str(new_row['parent_index'])\
    
    
    new_rows = rows[:]
    index = 0
    for parent_row in parent_rows:     
        parent_index = parent_row['parent_index']
        vendor = rows[parent_index]['vendor']
        #是供应商子公司插入总计
        if vendor.parent == parent_row['vendor']:
#             print(parent_row['vendor'])
            new_rows.insert(parent_index + 1 + index, parent_row)
            index += 1
            
            
    result = {}
    result["lines"] =  new_rows
    result["lines_total"] =  totals
    result["parent_lines"] =  parent_rows
    result["year"] =  year
    result["month"] =  month
    return result
        

def write_payment_summary_list(sheet, result, rowx, exportDetail):
    year = result['year']
    month = result['month']
    owed_amount_before_year_lable = str(year - 1) + '年底欠款'
    owed_invoice_before_year_lable = str(year - 1) + '年底欠发票'
    receiving_total_lable = str(year) + '年发生额'
    
    if month == 1:
        owed_amount_before_month_lable = '截止' +  str(year-1) + '年' + '底欠款'
    else:
        owed_amount_before_month_lable = '截止' +  str(year) + '年' + str(month - 1) +'月底欠款'
    
    
    detail_head = [u'序号', u'类别', u'供应商',  owed_amount_before_year_lable, owed_invoice_before_year_lable, receiving_total_lable, u'实际未开发票', owed_amount_before_month_lable, u'实际应付款', u'送货', u'开票', u'付款']
    head_width =  [0x0d00,   0x0d00,  6000,  5000,  5000, 5000,  5000,   7000,   4000, 0x0d00,  0x0d00,   0x0d00]
    merge_col =   [1,         1,          1,       1,     1,         1,     1,       1,      1, 1, 1, 1]
    kinds =       'int       text      text    price     price     price   price     price        price  price  price  price'.split()
    style=        [ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz right'),
                   ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz left'),
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
                   ]
    
    heading_xf = {'style' : style,
                   'width' : head_width,
                   'merge_col' : merge_col}
    
    if exportDetail :
        detail_head.insert(3, '公司')
        head_width.insert(3, 0x0d00)
        merge_col.insert(3, 1)
        kinds.insert(3, 'text')
        style.insert(3, ezxf('font:bold on, height 240; align: wrap on, vert centre, horiz left'))
        
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
    
    #只导出汇总
    if not exportDetail:
        for line in result['parent_lines']:
            #只导出合计         
            if line['index'] == -2:
                row = []
                row.append(index)
                row.append(line['vendor_category'].name if line['vendor_category'] else '')
                
                vendor_name = line['vendor'].short_name if line['vendor'].short_name else line['vendor'].name
                row.append(vendor_name)
                row.append(line['owed_amount_before_year'])
                row.append(line['owed_invoice_before_year'])
                row.append(line['receiving_total'])
                row.append(line['unreceiving_invoice'])
                row.append(line['owed_amount_before_month'])
                row.append(line['owed_amount'])
                row.append(line['month_receiving'])
                row.append(line['month_invoice'])
                row.append(line['month_payment'])
                data.append(row)
                index = index + 1
    else:#导出明细
        for line in result['lines']:
                row = []
                
                if line['index'] == -1 or line['index'] == -2:
                    row.append('')
                    row.append('')
                    
                else:
                    row.append(line['index'])
                    row.append(line['vendor_category'].name if line['vendor_category'] else '')
                
                vendor_name = line['vendor'].short_name if line['vendor'].short_name else line['vendor'].name
                row.append(vendor_name)
                
                if line['index'] == -1 or line['index'] == -2:
                    row.append('总计')
                else:
                    row.append(line['company'])
                
                
                row.append(line['owed_amount_before_year'])
                row.append(line['owed_invoice_before_year'])
                row.append(line['receiving_total'])
                row.append(line['unreceiving_invoice'])
                row.append(line['owed_amount_before_month'])
                row.append(line['owed_amount'])
                row.append(line['month_receiving'])
                row.append(line['month_invoice'])
                row.append(line['month_payment'])
                data.append(row)
                index = index + 1
    
    write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs)
    return index 
    
def generate_payment_summary(result, exportDetail):
    book = xlwt.Workbook(encoding='utf-8')
    sheet = book.add_sheet("payment_summary")
    report_title = str(result['year']) + '年' + str(result['month']) + '月付款金额汇总表'
    report_title_xf = ezxf('font: bold on, height 400; align: wrap on, vert centre, horiz center') 
    
    maxCol = 11
    if exportDetail:
        maxCol =  12
        
    
    sheet.write_merge(0, 2, 0, maxCol, report_title, report_title_xf)
    
    write_two_lines(sheet, 3, maxCol)
    
    
    line = write_payment_summary_list(sheet, result, 4, exportDetail)
    
    rowx = 4 + line
    write_line(sheet, rowx, maxCol)
    
    report_subtitle = u'合计'
    report_subtitle_xf = ezxf('font: height 240; align: wrap on, vert centre, horiz center')
    
    rowx = rowx+1
    
    mergeCol = 2
    if exportDetail:
        mergeCol = 3
    sheet.write_merge(rowx, rowx+1, 0, mergeCol, report_subtitle, report_subtitle_xf)
    
    data_format = 'font: height 240; align: wrap on, vert centre, horiz right'    
    report_subtitle_xf = ezxf(data_format, num_format_str='#,##0.00')
    
    #write 合计
    col = 3
    if exportDetail:
        col = 4
        
    for data in result['lines_total']:
        sheet.write_merge(rowx, rowx+1, col, col, data, report_subtitle_xf)
        col += 1
        
    
    return book        
        
    
    
    
    