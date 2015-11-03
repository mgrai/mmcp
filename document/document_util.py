# coding=utf-8
from django.db import connection

def build_query_for_purchase_quantity(documentLineItem):
    query = """select sum(purchase_quantity) as total_purchase_quantity
                      from order_orderline t 
                      left join document_documentlineitem d on
                      t.documentLineItem_id = d.id
                      left join project_projectmaterial p on
                      d.projectMaterial_id = p.id
                      where p.id = {0}  and t.documentLineItem_id = {1} """.format(documentLineItem.projectMaterial.id, documentLineItem.id)
    return query

def dictfetchall(cursor):
    "Returns all rows from a cursor as a dict"
    desc = cursor.description
    return [
        dict(zip([col[0] for col in desc], row))
        for row in cursor.fetchall()
    ]
        
def getPurchasedQuantity(documentLineItem):
    
    if documentLineItem.id is None:
        return 0
    
    query = build_query_for_purchase_quantity(documentLineItem)
    
    rows= []
    c = connection.cursor()
    try:
        c.execute(query)
        rows = dictfetchall(c)
    finally:
        c.close()
    quantity = rows[0]['total_purchase_quantity']
    if quantity is None:
         quantity = 0
    return quantity


def build_query_for_approved_quantity(documentLineItem):
    #把自己去除
    query = """select sum(coalesce(audit_quantity,expected_quantity)) as total_approved_quantity
                from document_documentlineitem d 
                    left join project_projectmaterial p on
                    d.projectMaterial_id = p.id
                    left join workflow_item i on
                    d.document_id = i.document_id
                    where p.id = {0} and i.status = 2 and d.id != {1}""".format(documentLineItem.projectMaterial.id, documentLineItem.id)
    return query

def getApprovedQuantity(documentLineItem):
    
    if documentLineItem.id is None:
        return 0
    
    query = build_query_for_approved_quantity(documentLineItem)
    
    rows= []
    c = connection.cursor()
    try:
        c.execute(query)
        rows = dictfetchall(c)
    finally:
        c.close()
    quantity = rows[0]['total_approved_quantity']
    if quantity is None:
         quantity = 0
    return quantity
        
