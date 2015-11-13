# coding=utf-8
from order.models import Order, OrderLine, ReceivingLine, Invoice
from document.models import Document, DocumentLineItem
from payment.models import Payment
from material.models import Vendor
from django.db.models import Q, Sum
from django.db.models.query import QuerySet
from django.http import HttpResponse
from django.db import connection
import StringIO
import xlwt
import datetime
from company.models import Company
ezxf = xlwt.easyxf
from xlwt import *
from xplugin.excel.excel_util import write_details, getNewBorder, write_line, write_two_lines
from monthdelta import MonthDelta
from setting.models import VendorSetting 
from company.models import *

def combine_lines(receivingLines):
    lines = []
    index = 0
    sum = 0
    unchecked_account_sum = 0
    for receivingLine in receivingLines:
        line = {}
        index = index + 1
        line['index'] = index
        line['id'] = receivingLine.id
        
        name = receivingLine.orderLine.documentLineItem.getMaterial()
        
        line['projectMaterialName'] = name
        line['brand'] = receivingLine.orderLine.brand.name if receivingLine.orderLine.brand else ''
        
        specification_name = receivingLine.orderLine.documentLineItem.getSpecification()
        line['specification'] = specification_name
        
        unit_name = receivingLine.orderLine.documentLineItem.getUnit()
        line['unit'] = unit_name
        
        #采购备注 跟到货备注都要显示
        comments = receivingLine.orderLine.documentLineItem.comments or ''
        if len(comments) > 0:
            comments += "    " + (receivingLine.comments or '')
        else:
            comments =(receivingLine.comments or '')
        
        
        line['comments'] = comments
        
        line['receiving_quantity'] = receivingLine.receiving_quantity
        line['receiving_date'] = receivingLine.receiving_date
        line['project'] = receivingLine.orderLine.documentLineItem.projectMaterial.project.name
        line['company'] = receivingLine.orderLine.documentLineItem.projectMaterial.project.company.name
        line['vendor'] = receivingLine.orderLine.order.vendor.short_name if receivingLine.orderLine.order.vendor.short_name else receivingLine.orderLine.order.vendor.name
        line['price'] = receivingLine.orderLine.price
        line['isCheckedAccount'] = bool(receivingLine.checkAccount)
        price = (receivingLine.orderLine.price or 0)
        quantity = (receivingLine.receiving_quantity or 0)
        total_price = price * quantity
        sum += total_price
        line['totalPrice'] = total_price
        if not line['isCheckedAccount']:
            unchecked_account_sum = unchecked_account_sum +  total_price
            
        lines.append(line)
    result = {}
    result['sum'] = sum
    result['unchecked_account_sum'] = unchecked_account_sum
    result['lines'] = lines
    return result

def build_receiving_parameters(start_date, end_date, vendors, company):
    args_list = [] 
    
    if start_date: 
        args_list.append(Q(receiving_date__gte=start_date)) 
        
    if end_date:
        args_list.append(Q(receiving_date__lte=end_date))
    
    if isinstance(vendors, QuerySet): 
        args_list.append(Q(orderLine__order__vendor__in=vendors))
    elif vendors: 
        args_list.append(Q(orderLine__order__vendor=vendors))
    
    if company:
        args_list.append(Q(orderLine__order__company__id=company.id))
        
    args = Q()  # defining args as empty Q class object to handle empty args_list
    for each_args in args_list :
        args = args & each_args
    return args

def build_check_account_parameters(start_date, end_date):
    args_list = [] 
    
    if start_date: 
        args_list.append(Q(checkAccount__start_date__gte=start_date)) 
        
    if end_date:
        args_list.append(Q(checkAccount__end_date__lte=end_date))
    
    args = Q()  # defining args as empty Q class object to handle empty args_list
    for each_args in args_list :
        args = args & each_args
    return args

def get_last_term_receiving_lines(start_date, end_date, vendors, company):
    receivingLines = []
    if start_date and end_date:
        #已对帐开始时间和结束时间为准
        args = build_receiving_parameters(None, None, vendors, company)
        
        args = args & build_check_account_parameters(start_date, end_date)
        
        receivingLines = ReceivingLine.objects.filter(*(args,)).filter(checkAccount__isnull = False).order_by('receiving_date') 
    return combine_lines(receivingLines)
    
    
def get_receiving_lines(start_date, end_date, vendors, company):
    
    args = build_receiving_parameters(start_date, end_date, vendors, company)
    
    receivingLines = ReceivingLine.objects.filter(*(args,)).order_by('receiving_date', 
                                                                     'orderLine__documentLineItem__projectMaterial__project__name',
                                                                     'orderLine__documentLineItem__projectMaterial__material__category__name',
                                                                     'orderLine__documentLineItem__projectMaterial__material__name',
                                                                     'orderLine__documentLineItem__projectMaterial__material__specification')
     
    
    #查找6个月之前没有对帐的
    args = Q()
    if start_date:
        before_six_month = datetime.datetime.strptime(start_date, '%Y-%m-%d').date() - MonthDelta(6)
        
        #包括所有的子供应商
        args = build_receiving_parameters(before_six_month, start_date, vendors, company)
        
        before_six_month_receivingLines = ReceivingLine.objects.filter(*(args,)).filter(checkAccount__isnull=True).order_by('receiving_date', 
                                                                                                                         'orderLine__documentLineItem__projectMaterial__project__name',
                                                                                                                         'orderLine__documentLineItem__projectMaterial__material__category__name',
                                                                                                                         'orderLine__documentLineItem__projectMaterial__material__name',
                                                                                                                         'orderLine__documentLineItem__projectMaterial__material__specification')
        receivingLines = before_six_month_receivingLines | receivingLines
        
    
    return combine_lines(receivingLines)

def get_last_term_invoices(start_date, end_date, vendors, company):
    if start_date and end_date:
        return get_invoices(start_date, end_date, vendors, company)
    else:
        return build_invoices_result([])

def get_invoices(start_date, end_date, vendors, company):
    args_list = [] 
    
    if start_date:
        args_list.append(Q(receive_date__gte=start_date)) 
        
    if end_date:
        args_list.append(Q(receive_date__lte=end_date))
    
        
    if isinstance(vendors, QuerySet): 
        args_list.append(Q(vendor__in=vendors))
    elif vendors: 
        args_list.append(Q(vendor=vendors))
        
    if company:
        args_list.append(Q(company__id=company.id))
    
        
    args = Q()  # defining args as empty Q class object to handle empty args_list
    for each_args in args_list :
        args = args & each_args
    
    invoices = Invoice.objects.filter(*(args,)).order_by('-receive_date')
    return build_invoices_result(invoices)
    

def build_invoices_result(invoices):
    sum = 0
    for invoice in invoices:
        sum = sum + (invoice.amount or 0)
        
    result = {}
    result['invoices_sum'] = sum
    result['invoices'] = invoices
    return result
    

def combin_sum_by_project_and_company(query):
    rows= []
    c = connection.cursor()
    try:
        c.execute(query)
        rows = dictfetchall(c)
    finally:
        c.close()
    
    results = {}
    projects = set()
    companies = set()
    for row in rows:
        projects.add(row['project_name'])
        companies.add(row['company_name'])
    
#     rows: [{'total': 40, 'project_name': u'北极星花园', 'company_name': u'南消'},
#            {'total': 50, 'project_name': u'湖畔天城',   'company_name': u'合和'}]
    list = []
    for project in projects:
        data = [project]
        for company in companies:
            total = ''
            for row in rows:
                project_name = row['project_name']
                company_name = row['company_name']
                if project_name == project and company_name == company:
                    total = row['total']
            #项目金额 
            data.append(total)
        list.append(data)
    
    #加最后一行 ‘合计’
    if len(rows) > 0:
        data = [u'合计']
        sum={}
        for row in rows:
            company_name = row['company_name']
            total = row['total']
            if sum.has_key(company_name) :
                sum[company_name] = sum[company_name] + total
            else:
                sum[company_name] = total
                
        for company in companies:
            data.append(sum[company])   
            
        
        list.append(data)
    
    
    results['projects'] = projects
    results['companies'] = companies
    results['companies_length'] = len(companies) + 1
    results['rows'] = list
    return results
    
def get_sum_by_project_and_company(start_date, end_date, vendors, company):
    ids = []
    for vendor in vendors:
        ids.append(str(vendor.id))
    
    query = """SELECT company.name AS company_name, 
                      project.name AS project_name, 
                      sum(receiving.total) AS total 
               FROM order_receivingline receiving
               JOIN order_orderline orderline ON
               receiving.orderLine_id = orderline.id
               JOIN order_order orders ON
               orderline.order_id = orders.id
               JOIN project_project project ON
               orders.project_id = project.id
               JOIN company_company company ON
               project.company_id = company.id
               JOIN material_vendor vendor ON
               orders.vendor_id = vendor.id
               WHERE receiving.checkAccount_id IS NULL
               """ 
    
    if bool(vendors):
        query = query + "AND vendor.id in %s  """ % str(ids).replace("[", "(").replace("]", ")")
        
     
    if start_date:
        before_six_month = datetime.datetime.strptime(start_date, '%Y-%m-%d').date() - MonthDelta(6)
        query = query + "AND receiving.receiving_date >= '%s'" %before_six_month
         
    if end_date:
        query = query + "AND receiving.receiving_date <= '%s'" %end_date
     
     
    if company:
        query = query + "AND company.name = '%s'" % company
     
    query = query + " GROUP BY project.id"
    return combin_sum_by_project_and_company(query)

def get_sum_by_project_and_company_by_receiving_lines(receivingLines):
       
    ids = []
    for receiving in receivingLines:
        ids.append(str(receiving.id))
    
    if len(ids) == 0:
        ids = [-999999999,]
        
    
        
    query = """SELECT company.name AS company_name, 
                      project.name AS project_name, 
                      sum(receiving.total) AS total 
               FROM order_receivingline receiving
               JOIN order_orderline orderline ON
               receiving.orderLine_id = orderline.id
               JOIN order_order orders ON
               orderline.order_id = orders.id
               JOIN project_project project ON
               orders.project_id = project.id
               JOIN company_company company ON
               project.company_id = company.id
               WHERE receiving.id in  %s """ % str(ids).replace("[", "(").replace("]", ")")
     
    query = query + " GROUP BY project.id"
    return combin_sum_by_project_and_company(query)
    
    
        
def dictfetchall(cursor):
    "Returns all rows from a cursor as a dict"
    desc = cursor.description
    return [
        dict(zip([col[0] for col in desc], row))
        for row in cursor.fetchall()
    ]

def get_last_term_payment_details(start_date, end_date, vendors, company): 
    if start_date and end_date:
        return get_payment_details(start_date, end_date, vendors, company)
    else:                    
        return build_payments_result([])
        
        
def get_payment_details(start_date, end_date, vendors, company): 
    args_list = [Q(is_closed=True)] 
    
    if start_date:
        args_list.append(Q(payment_date__gte=start_date)) 
        
    if end_date:
        args_list.append(Q(payment_date__lte=end_date))
        
    
    if isinstance(vendors, QuerySet): 
        args_list.append(Q(vendor__in=vendors))
    elif vendors: 
        args_list.append(Q(vendor=vendors))
        
    if company:
        args_list.append(Q(company__id=company.id))
        
    args = Q()  # defining args as empty Q class object to handle empty args_list
    for each_args in args_list :
        args = args & each_args
    
    payments = Payment.objects.filter(*(args,)).order_by('-payment_date')
    
    return build_payments_result(payments)

def build_payments_result(payments):
    sum = 0
    for payment in payments:
        if bool(payment.applied_amount) :
            sum += payment.applied_amount
        else:
            sum += payment.payment_amount
            
    result = {}
    result['payments_sum'] = sum
    result['payments'] = payments 
    return result 
           
def get_total_amounts(receiving_lines, invoices, payments, start_date, end_date, vendors, company):
    #上期开始日期
    last_month_start_date = None
    #上期结束日期
    last_month_end_date = None
    
    if start_date:
        delta = datetime.timedelta(days=1)
        if not isinstance(start_date, datetime.date):
            new_start_date = datetime.datetime.strptime(start_date, "%Y-%m-%d").date()
        else:
            new_start_date = start_date
        #前一天
        before_date = new_start_date - delta
        last_month_start_date = new_start_date - MonthDelta(1)
        last_month_end_date = before_date
    
    
    #上期欠款金额  = 上个月欠款
    last_term_owed_amount = getOwedAmountByYear(last_month_start_date.year, last_month_start_date.month, vendors, company)
    
    #累计应付款 = 本期供货金额 - 本期付款金额 + 上期欠款金额
    total_owed_amount = (receiving_lines['unchecked_account_sum'] or 0) - (payments['payments_sum'] or 0) + (last_term_owed_amount or 0)
    
    #上期欠发票  = 上个月欠发票
    last_term_owed_invoices = getOwedInvoiceByYear(last_month_start_date.year, last_month_start_date.month, vendors, company)
    
    #累计应开票 = 本期供货金额 - 本期开票金额 + 上期欠发票
    total_owed_invoices = (receiving_lines['unchecked_account_sum'] or 0) - (invoices['invoices_sum'] or 0) + (last_term_owed_invoices or 0)
    result = {'last_term_owed_amount' : last_term_owed_amount, 
              'total_owed_amount': total_owed_amount,
              'last_term_owed_invoices': last_term_owed_invoices,
              'total_owed_invoices': total_owed_invoices}
    
    return result
    
    
        
                      
def get_account_details(start_date, end_date, vendor_name, company):
    result = {}
    #包括所有子公司
    vendors = getVendorGroups(vendor_name)
    
    receiving_lines = get_receiving_lines(start_date, end_date, vendors, company)
    totals_by_project = get_sum_by_project_and_company(start_date, end_date, vendors, company)
    
    invoices = get_invoices(start_date, end_date, vendors, company)
    payments = get_payment_details(start_date, end_date, vendors, company)
    
    total_amount = get_total_amounts(receiving_lines, invoices, payments, start_date, end_date, vendors, company)
    
    result['payments'] = payments['payments']
    result['payments_sum'] = payments['payments_sum']
    result['totals_by_project'] = totals_by_project
    result['receiving_list'] = receiving_lines['lines']
    result['receiving_sum'] = receiving_lines['sum']
    result['receiving_unchecked_account_sum'] = receiving_lines['unchecked_account_sum']
    result['invoices'] = invoices['invoices']
    result['invoices_sum'] = invoices['invoices_sum']
    result['start_date'] = start_date
    result['end_date'] = end_date
    result['vendor_name'] = vendor_name
    result['company'] = company.name if bool(company) else company 
    result['last_term_owed_amount'] = total_amount['last_term_owed_amount']
    result['total_owed_amount'] = total_amount['total_owed_amount']
    result['last_term_owed_invoices'] = total_amount['last_term_owed_invoices']
    result['total_owed_invoices'] = total_amount['total_owed_invoices']
    
    return result


def exportCheckAccountExcel(checkAccount, receivingLines):
    file_type = 'xls'
    file_name = 'vendor'
    response = HttpResponse(mimetype="%s; charset=UTF-8" % 'application/vnd.ms-excel')
    response['Content-Disposition'] = ('attachment; filename=%s.%s' % (file_name, file_type)).encode('utf-8') 
    response.write(get_check_account_xls_export(checkAccount, receivingLines))
    return response

def get_check_account_xls_export(checkAccount, receivingLines):
    output = StringIO.StringIO()
    result = {}
    details = combine_lines(receivingLines)
    result['receiving_list'] = details['lines']
    result['receiving_sum'] = details['sum']
    details['unchecked_account_sum']= details['sum']
    result['receiving_unchecked_account_sum'] = details['unchecked_account_sum']
    
    start_date = checkAccount.start_date or ''
    end_date = checkAccount.end_date or ''
    vendor_name = checkAccount.vendor.name or ''
    company = checkAccount.company if checkAccount.company else None
    
    result['start_date'] = start_date
    result['end_date'] = end_date
    result['company'] = company
    result['check_account_id'] = checkAccount.check_account_id
    
    totals_by_project = get_sum_by_project_and_company_by_receiving_lines(receivingLines)
    
    vendors = getVendorGroups(vendor_name)
    
    invoices = get_invoices(start_date, end_date, vendors, company)
    payments = get_payment_details(start_date, end_date, vendors, company)
    
    total_amount = get_total_amounts(details, invoices, payments, start_date, end_date, vendors, company)
    
    result['vendors'] = vendors
    result['payments'] = payments['payments']
    result['payments_sum'] = payments['payments_sum']
    result['invoices'] = invoices['invoices']
    result['invoices_sum'] = invoices['invoices_sum']
    result['totals_by_project'] = totals_by_project
    
    result['last_term_owed_amount'] = total_amount['last_term_owed_amount']
    result['total_owed_amount'] = total_amount['total_owed_amount']
    result['last_term_owed_invoices'] = total_amount['last_term_owed_invoices']
    result['total_owed_invoices'] = total_amount['total_owed_invoices']
    
    book = generate_account_details(result) 
    
    book.save(output)
    output.seek(0)
    return output.getvalue()        
            
def write_receiving_list(sheet, result, rowx, has_brand_name):
    
    detail_head = [u'序号', u'送货日期', u'工程项目', u'材料名称']
    head_width  = [1500,     5000,      8000,        5000]
    merge_col   = [1,         1,          1,          1]
    kinds       = 'int      date        text       text'
    style       = [ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'), 
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left')
                    ]
    
    if has_brand_name:
        detail_head.append(u'品牌')
        head_width.append(0x0d00)
        merge_col.append(1)
        kinds += '   text'
        style += [ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left')] 
        
    detail_head += [u'规格', u'单位', u'数量', u'单价', u'金额',  u'备注']
    head_width  += [5000,   2500,    2500,   5000,     5000,  5000]
    merge_col   += [1,         1,       1,       1,     1,         1]
    kinds       += '   text   text     float      money   money   text'
    style       += [ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'), 
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz center'),
                    ]
    
    kinds = kinds.split()
        

    heading_xf = {'style' : style,
                   'width' : head_width,
                   'merge_col' : merge_col}
    data_format = 'font: height 240; align: wrap on, vert centre, horiz left'
    number_format = 'font: height 240; align: wrap on, vert centre, horiz right'
    kind_to_xf_map = {
            'date': ezxf(data_format , num_format_str='yyyy-mm-dd'),
            'int': ezxf(number_format, num_format_str='#,##0'),
            'float': ezxf(number_format, num_format_str='#0.00'),
            'money': ezxf(number_format , num_format_str='#,##0.00'),
            'price': ezxf(number_format, num_format_str='#0.00'),
            'text': ezxf(data_format),
            }
    data_xfs = [kind_to_xf_map[k] for k in kinds]
    
    data = []
    index = 1
    for line in result['receiving_list']:
        row = []
        row.append(index)
        row.append(line['receiving_date'])
        row.append(line['project'])
        row.append(line['projectMaterialName'])
        row.append(line['brand'])
        row.append(line['specification'])
        row.append(line['unit'])
        row.append(line['receiving_quantity'])
        row.append(line['price'])
        row.append(line['totalPrice'])
        row.append(line['comments'])
        data.append(row)
        index = index + 1
    
    # 移掉 品牌不用显示    
    if has_brand_name is False:
        for row in data:
            del row[4]
    
    write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs, False)
    
def write_payments_list(sheet, result, rowx):
    
    detail_head = [u'申请付款日期', u'实际付款日期', u'付款方式', u'公司', u'金额']
    head_width =  [2000,             2000,           3500,   5000,  5000]
    merge_col =   [2,                2,           1,          4,      1]
    kinds =       'date             date       text       text      money'.split()
    style =       [ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'), 
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ]
    heading_xf = {'style' : style,
                   'width' : head_width,
                   'merge_col' : merge_col}
    data_format = 'font: height 240; align: wrap on, vert centre, horiz left'
    number_format = 'font: height 240; align: wrap on, vert centre, horiz right'
    kind_to_xf_map = {
            'date': ezxf(data_format , num_format_str='yyyy-mm-dd'),
            'int': ezxf(number_format, num_format_str='#,##0'),
            'money': ezxf(number_format , num_format_str='#,##0.00'),
            'price': ezxf(number_format, num_format_str='#0.00'),
            'text': ezxf(data_format),
            }
    data_xfs = [kind_to_xf_map[k] for k in kinds]
    
    data = []
    for line in result['payments']:
        row = []
        row.append(line.create_time)
        row.append(line.payment_date)
        row.append(line.paymentType.name)
        row.append(line.company.name)
        row.append(line.applied_amount if line.applied_amount else line.payment_amount)
        data.append(row)
    
    write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs, False) 
    
def write_invoices_list(sheet, result, rowx):
    
    detail_head = [u'发票日期', u'发票号码', u'公司', u'金额']
    head_width =  [1500,    3500,   5000,  5000]
    merge_col =   [2,         2,          4,          1]
    kinds =       'date       text       text      money'.split()
    style =       [ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'), 
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ]
    
    heading_xf = {'style' : style,
                   'width' : head_width,
                   'merge_col' : merge_col}
    data_format = 'font: height 240; align: wrap on, vert centre, horiz left'
    number_format = 'font: height 240; align: wrap on, vert centre, horiz right'
    kind_to_xf_map = {
            'date': ezxf(data_format , num_format_str='yyyy-mm-dd'),
            'int': ezxf(number_format, num_format_str='#,##0'),
            'money': ezxf(number_format , num_format_str='#,##0.00'),
            'price': ezxf(number_format, num_format_str='#0.00'),
            'text': ezxf(data_format),
            }
    data_xfs = [kind_to_xf_map[k] for k in kinds]
    
    data = []
    for line in result['invoices']:
        row = []
        row.append(line.date)
        row.append(line.invoice_number)
        row.append(line.company.name)
        row.append(line.amount)
        data.append(row)
    
    write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs, False)                  
            
def write_totals_by_project(sheet, result, rowx):
    
    report_subtitle_style = 'font: height 240; align: wrap on, vert centre, horiz right'
    report_subtitle_xf = ezxf(report_subtitle_style)
    
    for colx, value in enumerate(result['totals_by_project']['companies']):
        new_col = colx * 2 + 2
        merge_col = new_col + 1 
        sheet.write_merge(rowx, rowx, new_col, merge_col, value, report_subtitle_xf)
        sheet.row(rowx).height = 400
        
    
    report_subtitle_xf = ezxf(report_subtitle_style , num_format_str='#,##0.00')
    for row in result['totals_by_project']['rows']:
        rowx += 1
        for colx, value in enumerate(row):
            if len(str(value)) > 0:
                new_col = colx * 2 
                merge_col =  new_col + 1
                sheet.write_merge(rowx, rowx, new_col, merge_col, value, report_subtitle_xf) 
                sheet.row(rowx).height = 350     
            
def write_total_amounts(sheet, result, rowx, hasBrandName):
    detail_head = [u'本期供货金额', u'本期付款金额', u'上期欠款金额', u'累计应付款', u'本期开票金额', u'上期欠发票', '累计应开票']
    head_width =  [2500,          5000,          5000,            2500,        2500,         2500,         5000]
    merge_col =   [2,                1,                1,          2,           2,              2,            1]
    style     =   [ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'), 
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right')]
    
    if hasBrandName is False:
        head_width =  [2500,          5000,          5000,            5000,        2500,         2500,         5000]
        merge_col =   [2,                1,            1,             1,           2,              2,            1]
    
    
    kinds =       'money           money               money      money         money           money       money'.split()
    heading_xf = {'style' : style,
                   'width' : head_width,
                   'merge_col' : merge_col}
    data_format = 'font: height 240; align: wrap on, vert centre, horiz left'
    number_format = 'font: height 240; align: wrap on, vert centre, horiz right'
    kind_to_xf_map = {
            'date': ezxf(data_format , num_format_str='yyyy-mm-dd'),
            'int': ezxf(number_format, num_format_str='#,##0'),
            'money': ezxf(number_format , num_format_str='#,##0.00'),
            'price': ezxf(number_format, num_format_str='#0.00'),
            'text': ezxf(data_format),
            }
    data_xfs = [kind_to_xf_map[k] for k in kinds]
    
    data = []
    row = []
    row.append(result['receiving_unchecked_account_sum'])
    row.append(result['payments_sum'])
    row.append(result['last_term_owed_amount'])
    row.append(result['total_owed_amount'])
    row.append(result['invoices_sum'])
    row.append(result['last_term_owed_invoices'])
    row.append(result['total_owed_invoices'])
    data.append(row)
        
    write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs, False)
    

def has_brand_name(result):
    flag = False
    for line in result['receiving_list']:
        if len(line['brand']) > 0:
            flag = True
            break
    return flag
            
        
        
        
def generate_account_details(result):
    book = xlwt.Workbook(encoding='utf-8')
    sheet = book.add_sheet("account_detail")
    hasBrandName = has_brand_name(result)
    max_column = 9
    if hasBrandName:
        max_column = 10
    
    
    
    company_name = result['company'].name if result['company'] else '' 
    
    rowx = 0
    report_title = company_name
    report_title_xf = ezxf('font: bold on, height 300; align: wrap on, vert centre, horiz left')
    sheet.write_merge(rowx, rowx+1, 0, max_column, report_title, report_title_xf)
    
#     rowx += 2    
#     report_title = nanxiao_company.name
#     sheet.write_merge(rowx, rowx+1, 0, max_column, report_title, report_title_xf)
    
    rowx += 2    
    report_title = u'对帐单'
    report_title_xf = ezxf('font: bold on, height 400; align: wrap on, vert centre, horiz center') 
    sheet.write_merge(rowx, rowx+2, 0, max_column, report_title, report_title_xf)
    
    rowx += 3    
    write_two_lines(sheet, rowx, max_column)
    
    report_subtitle_style = 'font: height 240; align: wrap on, vert centre, horiz left'
    report_subtitle_xf = ezxf(report_subtitle_style)
    
    rowx += 1    
    report_subtitle = u'供应商名称：' 
    sheet.write_merge(rowx, rowx+len(result['vendors'])*2 -1, 0, 1, report_subtitle, report_subtitle_xf) 
    
    report_subtitle = u'传真：'  + result['vendors'][0].fax
    sheet.write_merge(rowx, rowx+len(result['vendors'])*2 -1, 7, max_column, report_subtitle, report_subtitle_xf)
    
    for vendor in result['vendors']:
        sheet.write_merge(rowx, rowx+1, 2, 6, vendor.name, report_subtitle_xf) 
        rowx +=2
    
    report_subtitle = u'对帐日期：' + str(result['start_date']) + ' - ' + str(result['end_date'])
    sheet.write_merge(rowx, rowx+1, 0, 6, report_subtitle, report_subtitle_xf)
    
    report_subtitle = u'对帐编号：' + result['check_account_id'] 
    sheet.write_merge(rowx, rowx+1, 7, max_column, report_subtitle, report_subtitle_xf)
    
    rowx += 2
    write_line(sheet, rowx, max_column)
    
    rowx += 1
    write_total_amounts(sheet, result, rowx, hasBrandName)
    
    rowx += 2 
    write_line(sheet, rowx, max_column)
    
    rowx += 1
    report_subtitle = u'送货清单' 
    sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
     
    rowx += 2
    write_line(sheet, rowx, max_column)
     
    rowx += 1
    write_receiving_list(sheet, result, rowx, hasBrandName)
     
    rowx = rowx + len(result['receiving_list']) + 1
      
    write_line(sheet, rowx, max_column)
      
    rowx += 1
    report_subtitle = u'合计'
    data_format = ezxf('font: height 240; align: wrap on, vert centre, horiz centre') 
    sheet.write_merge(rowx, rowx, 0, max_column-2, report_subtitle, data_format)
     
    col = max_column-1
    report_subtitle_style = 'font: height 240; align: wrap on, vert centre, horiz right'
    sheet.write_merge(rowx, rowx, col, col, result['receiving_sum'], ezxf(report_subtitle_style , num_format_str='#,##0.00'))
      
    rowx += 1
    write_line(sheet, rowx, max_column)
       
       
    rowx += 1
    report_subtitle = u'统计分类' 
    sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
       
    rowx += 2
    write_line(sheet, rowx, max_column)
       
    rowx +=1
    #统计分类
    write_totals_by_project(sheet, result, rowx)
        
    rowx += len(result['totals_by_project']['rows']) + 1
        
    write_line(sheet, rowx, max_column)
     
    if len(result['invoices']) > 0:  
        rowx += 1
          
        report_subtitle = u'发票清单' 
        sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
             
        rowx += 2
        write_line(sheet, rowx, max_column)
             
        rowx += 1
        write_invoices_list(sheet, result, rowx)
              
        rowx = rowx + len(result['invoices']) + 1
        write_line(sheet, rowx, max_column)
              
        rowx += 1
              
        report_subtitle = u'合计'
        sheet.write_merge(rowx, rowx, 0, 7, report_subtitle, data_format)
        sheet.write_merge(rowx, rowx, 8, 8, result['invoices_sum'], ezxf(report_subtitle_style , num_format_str='#,##0.00'))
        
        rowx += 1
        write_line(sheet, rowx, max_column) 
     
    if len(result['payments']) > 0: 
            
        rowx += 1
        report_subtitle = u'付款明细' 
        sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
            
        rowx += 2
        write_line(sheet, rowx, max_column)
            
        rowx += 1
        write_payments_list(sheet, result, rowx)
            
        rowx = rowx + len(result['payments']) + 1
        write_line(sheet, rowx, max_column)
            
        rowx += 1
        report_subtitle = u'合计'
        sheet.write_merge(rowx, rowx, 0, 8, report_subtitle, data_format)
        sheet.write_merge(rowx, rowx, 9, 9, result['payments_sum'], ezxf(report_subtitle_style , num_format_str='#,##0.00')) 
            
        rowx += 1
        write_line(sheet, rowx, max_column)
         
       
    
    col = 6
    if hasBrandName:
        col = 7
        
    data_format = ezxf('font: height 240; align: wrap on, vert centre, horiz left') 
    rowx += 1
    report_subtitle = u'供应商签章'
    sheet.write_merge(rowx, rowx+1, 0, col, report_subtitle, data_format)
         
    hehe_company = Company.objects.filter(short_name = '合和')[0]
         
    report_subtitle = u'请确认后回传至：' + hehe_company.fax
    sheet.write_merge(rowx, rowx+1, col+1, max_column, report_subtitle, data_format)
    return book
    
def build_vendor_setting_parameters(vendors, company):
    args_list = [] 
    
    if isinstance(vendors, QuerySet): 
        args_list.append(Q(vendor__in = vendors))
    elif vendors: 
        args_list.append(Q(vendor = vendors))
        
    if company:
        args_list.append(Q(company__id = company.id))
    
    args = Q()  # defining args as empty Q class object to handle empty args_list
    for each_args in args_list :
        args = args & each_args
    return args
    
def getOwedAmountBeforeOnline(vendors, company):
    owed_amount = 0
    
    args = build_vendor_setting_parameters(vendors, company)

    vendorSettings = VendorSetting.objects.filter(*(args,))
    for vendorSetting in vendorSettings:
        owed_amount += (vendorSetting.online_before_owed_amount or 0)
            
    return owed_amount

def getOwedInvoiceBeforeOnline(vendors, company):
    owed_invoice = 0
    args = build_vendor_setting_parameters(vendors, company)
     
    vendorSettings = VendorSetting.objects.filter(*(args,))
    
    for vendorSetting in vendorSettings:
            owed_invoice += (vendorSetting.online_before_owed_invoice or 0)
            
    return owed_invoice  


def getReceivedAmountBeforeOnline(vendors, company):
    received_amount = 0
    args = build_vendor_setting_parameters(vendors, company)

    vendorSettings = VendorSetting.objects.filter(*(args,))
    for vendorSetting in vendorSettings:
        received_amount += (vendorSetting.online_before_received_amount or 0)
            
    return received_amount 

#已欠款 按月份
def getOwedAmountByYear(year, month, vendor, company):
    #上线前欠款
    owed_amount = getOwedAmountBeforeOnline(vendor, company)
    #已送货
    receiving_total = getTotalReceivingByMonth(year, month, vendor, company)
    
    #已送货款 + 上线前欠款
    owed_amount += receiving_total
    
    #已付款
    payment_amount = getTotalPaymentByMonth(year, month, vendor, company)
    
    owed_amount -= payment_amount       
    
    return owed_amount

#已欠发票  按月份
def getOwedInvoiceByYear(year, month, vendor, company):
    #上线前欠发票
    owed_invoice = getOwedInvoiceBeforeOnline(vendor, company)
    
    #已送货
    receiving_total = getTotalReceivingByMonth(year, month, vendor, company)
    
    owed_invoice += receiving_total 
    
    #已付发票
    invoice_total = getTotalInvoiceByMonth(year, month, vendor, company)
    
    owed_invoice -= invoice_total      
    
    return owed_invoice

def getAllCompany(self):
    #parent
    company_queryset = Company.objects.filter(name = self.user.company.name)
    
    all_company = None
    
    if bool(company_queryset):
        company = company_queryset[0]
        
        if company.parent is None:
            
            childs = Company.objects.filter(parent__name = company.name)
            all_company = company_queryset | childs
        else:
            parent = Company.objects.filter(name = company.parent.name)
            childs = Company.objects.filter(parent__name = company.parent.name)
            
            all_company = parent | childs
    
    return all_company

def getAllCompanyIds(self):
    
    all_company = getAllCompany(self)
    
    company_ids = []
    for company in all_company:
        company_ids.append(str(company.id))
    
    return company_ids

def getAllVendor(self):
    company_ids = getAllCompanyIds(self)
    return Vendor.objects.filter(company__id__in = company_ids).order_by('category__id', 'tree_id', 'lft')

def getAllParentVendor(self):
    company_ids = getAllCompanyIds(self)
    return Vendor.objects.filter(company__id__in = company_ids, parent__isnull=True).order_by('category__id', 'tree_id', 'lft')

def getAllUsers(self, GROUP_NAME):
    company_ids = getAllCompanyIds(self)
    return Employee.objects.filter(company__id__in = company_ids, groups__name__contains = GROUP_NAME)
        

#公司（包括所有子公司） 总欠款
def getOwedAmount(self, year, month, vendor):
    
    companies = getAllCompany(self)
    total = 0
    for company in companies:
        total += getOwedAmountByYear(year, month, vendor, company)
    return total

def getTotalInvoiceByMonth(year, month, vendor, company):
    start_date = get_first_date_of_month(year, 1)
    end_date = get_last_date_of_month(year, month)
    
    args_list = [] 
    if vendor: 
        args_list.append(Q(vendor = vendor))
    if company:
        args_list.append(Q(company__id = company.id))
    if start_date:
        args_list.append(Q(receive_date__gte = start_date))
    if end_date:
        args_list.append(Q(receive_date__lte = end_date))
        
    
    args = Q()  # defining args as empty Q class object to handle empty args_list
    for each_args in args_list :
        args = args & each_args
    
    invoice = Invoice.objects.filter(*(args,)).aggregate(total = Sum('amount'))
    return (invoice['total'] or 0)  

def getTotalReceivingByMonth(year, month, vendor, company):
    start_date = get_first_date_of_month(year, 1)
    end_date = get_last_date_of_month(year, month)
    
    args_list = [] 
    if vendor: 
        args_list.append(Q(orderLine__order__vendor = vendor))
    if company:
        args_list.append(Q(orderLine__order__company__id = company.id))
    if start_date:
        args_list.append(Q(checkAccount__start_date__gte = start_date))
    if end_date:
        args_list.append(Q(checkAccount__end_date__lte = end_date))
        
    args_list.append(Q(checkAccount__isnull = False))
    
    
    args = Q()  # defining args as empty Q class object to handle empty args_list
    for each_args in args_list :
        args = args & each_args
    
    receiving = ReceivingLine.objects.filter(*(args,)).aggregate(total = Sum('total'))
    return (receiving['total'] or 0) 

def get_first_date_of_month(year, month):
    return datetime.date(year, month, 1)

def get_last_date_of_month(year, month):
    delta = datetime.timedelta(days=1)
    if month == 12:
        next_month = datetime.date(year + 1, 1, 1)
    else:
        next_month = datetime.date(year, month + 1, 1)
    return next_month - delta


def getTotalPaymentByMonth(year, month, vendor, company):
    start_date = get_first_date_of_month(year, 1)
    end_date = get_last_date_of_month(year, month)
    
    args_list = [] 
    if vendor: 
        args_list.append(Q(vendor = vendor))
    if company:
        args_list.append(Q(company__id = company.id))
    if start_date:
        args_list.append(Q(payment_date__gte = start_date))
    if end_date:
        args_list.append(Q(payment_date__lte = end_date))
        
    args_list.append(Q(is_closed = True))
    
    
    args = Q()  # defining args as empty Q class object to handle empty args_list
    for each_args in args_list :
        args = args & each_args
    
    payments = Payment.objects.filter(*(args,))
    
    payment_amount = 0
    for payment in payments:
        if bool(payment.applied_amount) :
            payment_amount += payment.applied_amount
        else:
            payment_amount += payment.payment_amount
    return payment_amount
 
    
def getVendorGroups(vendor_name):
    #parent
    vendor = Vendor.objects.filter(name = vendor_name)
    #childs
    vendors = Vendor.objects.filter(parent = vendor)
    
    vendors = vendors | vendor
    
    return vendors