# coding=utf-8
import xlwt
import datetime
ezxf = xlwt.easyxf
from xlwt import *
from order.models import Order, OrderLine, OrderNote
from xplugin.excel.excel_util import write_details, getNewBorder, write_line, write_two_lines
from report_util import to_rmb_upper

def write_order_lines(sheet, data, rowx, has_brand_name, has_comments):
#     detail_head = [u'序号', u'品名', u'品牌', u'规格要求', u'单位', u'数量', u'含税单价', u'金额', u'交货日期', u'备注']
#     head_width =  [2000,  6000, 0x0d00, 0x0d00,  0x0d00,  0x0d00,  0x0d00, 0x0d00,  0x0d00,   0x0d00]
#     merge_col =   [1,         1,    1,        1,        1,      1,       1,        1,        1,      1]
#     kinds =        'int      text   text      text     text     int      price      money     date text'.split()

    detail_head = [u'序号', u'品名']
    head_width =  [2000,  6000]
    merge_col =   [1,      1]
    kinds = 'int      text'
    style = [ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'), 
             ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left')]
     
    if has_brand_name:
        detail_head.append(u'品牌')
        head_width.append(0x0d00)
        merge_col.append(1)
        kinds += '   text'
        style.append(ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'))
    else: # 移掉 品牌不用显示
        for row in data:
            del row[2]
        
     
    detail_head += (u'规格要求', u'单位', u'数量', u'含税单价', u'金额', u'交货日期')
    head_width  += (5000,    0x0d00,  0x0d00,    0x0d00,   0x0d00,  0x0d00)
    merge_col   += (1,         1,        1,       1,        1,      1)
    kinds       += '    text     text     int      price      money     date'
    style       += [ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'), 
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz right'),
                    ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left')]
    
    
    if has_comments:
        detail_head.append(u'备注')
        head_width.append(0x0d00)
        merge_col.append(1)
        kinds += '   text'
        style.append(ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'))
    else:# 移掉 备注不用显示
        for row in data:
            del row[-1]
    
    kinds = kinds.split()
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
    
    write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs, frozen_head = False)
            
def generate_order(order_id):
    
    order = Order.objects.filter(order_id = order_id)[0]
    lines = OrderLine.objects.filter(order__order_id = order_id).order_by('id')
    index = 1
    data = []
    total = 0
    has_brand_name = False
    has_comments = False
    for line in lines:
        row = []
        row.append(index)
        
        name = line.documentLineItem.getMaterial()
        row.append(name)
        
        brand = line.brand.name if line.brand else ''
        if len(brand)>0 :
            has_brand_name = True
        row.append(brand)
        
        name = line.documentLineItem.getSpecification()
        row.append(name )
        
        name = line.documentLineItem.getUnit()
        
        row.append(name)
        quantity = line.purchase_quantity or 0
        price = line.price or 0
        row.append(quantity)
        row.append(price)
        row.append(price * quantity)
        total = total + price * quantity
        row.append(line.expected_date)
        comments = line.documentLineItem.comments or ''
        if len(comments)>0 :
            has_comments = True
            comments += '    ' + (line.documentLineItem.approval_comments or '')
        elif len(line.documentLineItem.approval_comments or '') > 0:
            has_comments = True
            comments +=(line.documentLineItem.approval_comments or '')
            
            
        row.append(comments)
        data.append(row)
        index = index + 1
        
    
    book = xlwt.Workbook(encoding='utf-8')
    sheet = book.add_sheet("order")
    max_column = 8
     
    if has_brand_name and has_comments:
        max_column = 9        
    
    
    report_title = order.company.name
    report_title_xf = ezxf('font: bold on, height 500; align: wrap on, vert centre, horiz center')
    sheet.write_merge(0, 2, 0, max_column, report_title, report_title_xf)
    
    
    report_subtitle_xf = ezxf('font: height 240; align: wrap on, vert centre, horiz left')
    
    report_subtitle = u'地址：' + order.company.address
    sheet.write_merge(3, 4, 0, 5, report_subtitle, report_subtitle_xf)
     
    report_subtitle = u'邮编: ' + order.company.zip
    sheet.write_merge(3, 4, 6, max_column, report_subtitle, report_subtitle_xf) 
    
    report_subtitle = u'电话: ' + order.company.phone
    sheet.write_merge(5, 6, 0, 5, report_subtitle, report_subtitle_xf)
    
    if bool(order.company.fax):
        report_subtitle = u'传真: ' + order.company.fax
        sheet.write_merge(5, 6, 6, max_column, report_subtitle, report_subtitle_xf)
    
    write_two_lines(sheet, 7, max_column)
    
    report_subtitle = u'采购单'
    report_title_xf = ezxf('font: bold on, height 400; align: wrap on, vert centre, horiz center') 
    sheet.write_merge(8, 9, 0, max_column, report_subtitle, report_title_xf)
    
    report_subtitle = u'采购单号: ' + order_id
    sheet.write_merge(10, 11, 0, 2, report_subtitle, report_subtitle_xf)
    
    report_subtitle = u'内部编号: ' + order.document.document_id
    sheet.write_merge(10, 11, 3, 5, report_subtitle, report_subtitle_xf)
    
    report_subtitle = u'订购日期: ' + str(order.create_time)
    sheet.write_merge(10, 11, 6, max_column, report_subtitle, report_subtitle_xf)
    
    write_line(sheet, 12, max_column)
    
    report_subtitle = u'供应商：' + order.vendor.name if order.vendor is not None else ""  
    sheet.write_merge(13, 14, 0, max_column, report_subtitle, report_subtitle_xf)
    
    report_subtitle = u'联系人：' +  order.vendor.contact if order.vendor is not None else ""  
    sheet.write_merge(15, 16, 0, 2, report_subtitle, report_subtitle_xf)
    
    report_subtitle = u'电话：' + order.vendor.telephone if order.vendor is not None else ""  
    sheet.write_merge(15, 16, 3, 5, report_subtitle, report_subtitle_xf)
    
    if bool(order.vendor.fax):
        report_subtitle = u'传真: ' + order.vendor.fax 
        sheet.write_merge(15, 16, 6, max_column, report_subtitle, report_subtitle_xf)
    
    write_line(sheet, 17, max_column)
    
    report_subtitle = u'送货地点：' + order.project.name
    sheet.write_merge(18, 19, 0, max_column, report_subtitle, report_subtitle_xf)
    
    report_subtitle = u'联系人：' + str(order.project.users.all()[0])
    sheet.write_merge(20, 21, 0, 2, report_subtitle, report_subtitle_xf)
    
    report_subtitle = u'电话：' + order.project.users.all()[0].phone
    sheet.write_merge(20, 21, 3, max_column, report_subtitle, report_subtitle_xf)
    
    write_line(sheet, 22, max_column)
    
    rowx = 23
    write_order_lines(sheet, data, rowx, has_brand_name, has_comments)
    
    rowx = rowx+len(data)+1
    write_line(sheet, rowx, max_column)
    
    report_subtitle = u'合计'
    report_subtitle_xf = ezxf('font: height 240; align: wrap on, vert centre, horiz centre')
    
    rowx = rowx+1
    if has_brand_name:
        sheet.write_merge(rowx, rowx+1, 0, 6, report_subtitle, report_subtitle_xf)
    else:
        sheet.write_merge(rowx, rowx+1, 0, 5, report_subtitle, report_subtitle_xf)
    
    data_format = 'font: height 240; align: wrap on, vert centre, horiz right'
    report_subtitle_xf = ezxf(data_format,num_format_str='#,##0.00')
    
    if has_brand_name:
        sheet.write_merge(rowx, rowx+1, 7, 7, total, report_subtitle_xf)
    else:
        sheet.write_merge(rowx, rowx+1, 6, 6, total, report_subtitle_xf)
    
    report_subtitle_xf = ezxf('font: height 240; align: wrap on, vert centre, horiz left')
    rowx = rowx+2
    report_subtitle = u'合同总价:  '
    if total > 0:
        report_subtitle += to_rmb_upper(total)
    else:
        report_subtitle += '负' + to_rmb_upper(total * -1)
    sheet.write_merge(rowx, rowx+1, 0, max_column, report_subtitle, report_subtitle_xf)
    
    note = ''
    if order.note:
        note = order.note.note
        
#     note = u"""注意事项：
#                1. 签单回传： 供方应于二日内就本合同签章确认回传，逾期未签回视同本合同作废。
#                2. 交货事宜： 请供方务必遵守本合同交货日期、数量，如有变动应事先以书面传真
#                                         调整交货期。供方延迟交货对本公司造成重大损失的，其损失供方应付全责。
#                3. 质量要求： 符合国家标准及我方订货要求，如出现质量与订单不符现象同供方负责
#                                         退换，另扣除本合同总价的10%作为违约金。
#                4. 请款手续： 凭现场验收合格签收的送货单在每月的25日前至我司进行对账，次月
#                                         中旬付款。如当有不前来对账的将延至下个月，付款也如此。
#                5. 其它约定： 送货时请附产品检验报告及合格证原件。"""
    
    rowx = rowx+2
    sheet.write_merge(rowx, rowx+11, 0, max_column, note, getNewBorder(Alignment.HORZ_LEFT))

    rowx = rowx+12
    report_subtitle = u'采购'
    sheet.write_merge(rowx, rowx+1, 0, 3, report_subtitle, getNewBorder(Alignment.HORZ_CENTER))
    
    report_subtitle = u'供应商签章'
    sheet.write_merge(rowx, rowx+1, 4, max_column, report_subtitle, getNewBorder(Alignment.HORZ_CENTER))
    
    rowx = rowx +2
    sheet.write_merge(rowx, rowx+3, 0, 3, '', getNewBorder(Alignment.HORZ_CENTER))
    
    sheet.write_merge(rowx, rowx+3, 4, max_column, '', getNewBorder(Alignment.HORZ_CENTER))
    
    return book
    


    