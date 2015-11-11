# coding=utf-8
from django.http import HttpResponse
from django.db import connection
from report.vendor_account import dictfetchall

def build_query(project, category, material_name):
    query = """select t.project_name,
               t.material_name,
               t.category_name,
               t.materialName,
               t.project_material_id,
               sum(t.expected_quantity) AS total_expected_quantity,
               sum(t.audit_quantity) AS total_audit_quantity,
               sum(t.posted_quantity)  AS total_posted_quantity,
               sum(t.purchase_quantity) AS total_purchase_quantity
              from (
                select line.projectMaterial_id,
                       project.name AS project_name,
                       CONCAT(material.name ,  coalesce(CONCAT(' - ', material.specification), ''), coalesce(CONCAT(' - ', unit.name), '')) AS material_name,
                       category.name AS category_name,
                       line.expected_quantity,
                       line.audit_quantity,
                       line.posted_quantity,
                      sum(order_line.purchase_quantity) AS purchase_quantity, 
                      material.name AS materialName,
                      project_material.id AS project_material_id
                from document_documentlineitem line
            
                left join project_projectmaterial project_material on
                line.projectMaterial_id = project_material.id
            
                left join material_material material on
                project_material.material_id = material.id
                
                left join material_category category on
                material.category_id = category.id
            
                left join material_unit unit on
                material.unit_id = unit.id
            
                left join project_project project on
                project_material.project_id = project.id
            
                left join order_orderline order_line on
                 order_line.documentLineItem_id = line.id
            
                where project.name = '{0}' """.format(project)
    
    if len(category)>0:
        query += " AND category.name = '{0}' ".format(category)
    
    if len(material_name)>0:
        query += " AND material.name like '%{0}%' ".format(material_name)
             
    query += """ group by line.projectMaterial_id, line.id
                
             )t group by t.projectMaterial_id   order by t.category_name, t.materialName ASC,  t.project_material_id DESC """.format(project)
                 
            
    return query
    
def get_project_apply_list(project, category, material_name):
    query = build_query(project, category, material_name)
    
    rows= []
    c = connection.cursor()
    try:
        c.execute(query)
        rows = dictfetchall(c)
    finally:
        c.close()
        
    result = {}
    result['lines'] = rows
    result['project_name'] = project
    result['category_name'] = category
    result['material_name'] = material_name
    return result
        
