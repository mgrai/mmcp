# coding=utf-8
import xlwt
import datetime
ezxf = xlwt.easyxf
from xlwt import *

def line():
    brd = Borders()
    brd.left = 0x00
    brd.right = 0x00
    brd.top = 0x01
    brd.bottom = 0x00
    
    
    style = XFStyle()
    style.borders = brd
    return style

def two_lines():
    brd = Borders()
    brd.left = 0x00
    brd.right = 0x00
    brd.top = 0x01
    brd.bottom = 0x01
    
    
    style = XFStyle()
    style.borders = brd
    return style
    
#单元位加框
def getNewBorder(horz):
    brd = Borders()
    brd.left = 0x01
    brd.right = 0x01
    brd.top = 0x01
    brd.bottom = 0x01
    
    fnt = Font()
    fnt.height = 240
    
    al1 = Alignment()
#     al1.horz = Alignment.HORZ_LEFT
    al1.horz = horz
    al1.vert = Alignment.VERT_TOP
    
    style = XFStyle()
    style.font = fnt
    style.alignment = al1
    style.borders = brd
    return style

#写一条横线
def write_line(sheet, row, col):
    sheet.write_merge(row, row, 0, col, '', line())
    sheet.row(row).height_mismatch = True
    sheet.row(row).height  = 20

#写两条横线
def write_two_lines(sheet, row, col):
    sheet.write_merge(row, row, 0, col, '', two_lines())
    sheet.row(row).height_mismatch = True
    sheet.row(row).height  = 50  

#################################################################################################################
#           写名细代码如下
#
#     detail_head = [u'序号', u'材料名称', u'规格', u'单位', u'数量', u'单价', u'金额', u'送货日期', u'送货单位']
#     head_width =  [0x0d00,   0x0d00,   0x0d00,  0x0d00,  0x0d00,  0x0d00, 0x0d00,  4000,   0x0d00*2]
#     kinds =        'int       text      text    text     int     price   money     date        text'.split()
#     heading_xf =  {'style' : ezxf('font: bold on, height 240; align: wrap on, vert centre, horiz left'),
#                    'width' : head_width}
#     data_format = 'font: height 240; align: wrap on, vert centre, horiz left'
#     kind_to_xf_map = {
#             'date': ezxf(data_format ,num_format_str='yyyy-mm-dd'),
#             'int': ezxf(data_format, num_format_str='#,##0'),
#             'money': ezxf(data_format ,num_format_str='#,##0.00'),
#             'price': ezxf(data_format,num_format_str='#0.00'),
#             'text': ezxf(data_format),
#             }
#     data_xfs = [kind_to_xf_map[k] for k in kinds]
#     data = []
#     index = 1
#     for line in result['lines']:
#         row = []
#         row.append(index)
#         row.append(line['projectMaterialName'])
#         row.append(line['specification'])
#         row.append(line['unit'])
#         row.append(line['receiving_quantity'])
#         row.append(line['price'])
#         row.append(line['totalPrice'])
#         row.append(line['receiving_date'])
#         row.append(line['vendor'])
#         data.append(row)
#         index = index + 1
#     
#     write_details(sheet, rowx, detail_head, data, heading_xf, data_xfs) 
#################################################################################################################

def get_merge_col(index, mege_col):
    new_colx = 0
    for col in mege_col[:index+1]:
        new_colx += col
    return new_colx
        
    
def write_details(sheet, rowx, headings, data, heading_xf, data_xfs, frozen_head = True):
    
    for colx, value in enumerate(headings):
        merge_col = get_merge_col(colx, heading_xf['merge_col']) -1
        new_colx = merge_col - heading_xf['merge_col'][colx] + 1
        sheet.write_merge(rowx, rowx, new_colx, merge_col, value, heading_xf['style'][colx])
        sheet.col(colx).width = heading_xf['width'][colx]
        sheet.row(rowx).height_mismatch = True
        sheet.row(rowx).height = 400
        
        if frozen_head:
            sheet.set_panes_frozen(True) # frozen headings instead of split panes
            sheet.set_horz_split_pos(rowx+1) # in general, freeze after last heading row
            sheet.set_remove_splits(True) # if user does unfreeze, don't leave a split there
        
    for row in data:
        rowx += 1
        for colx, value in enumerate(row):
            merge_col = get_merge_col(colx, heading_xf['merge_col']) -1
            new_colx = merge_col - heading_xf['merge_col'][colx] + 1
            sheet.write_merge(rowx, rowx, new_colx, merge_col, value, data_xfs[colx])
            sheet.row(rowx).height_mismatch = True
            sheet.row(rowx).height = 350    
    
    