# coding=utf-8
from project.models import *
from mmcp.constant import *


ESTIMATE_GROUP_MANAGER = U'预算部门经理'
PURCHASE_GROUP_MANAGER = u'采购部门经理'
ACCOUNT_GROUP_MANAGER = u'财务部门经理'
VICE_GENERAL_MANAGER = u'副总经理'
GENERAL_MANAGER = u'总经理'

ACCOUNT_GROUP = u'财务部门'
PROJECT_GROUP = u'工程部门'
PURCHASE_GROUP = u'采购部门' 
ESTIMATE_GROUP = u'预算部门'


def isGroup(self, GROUP_NAME):
    result = False
    if len(self.user.groups.all()) > 0:
        for group in self.user.groups.all():
            if GROUP_NAME == group.name:
                result = True
                break
            
    return result 


def assign_material_to_project(self, project_id, material):
    project = Project.objects.get(id = project_id)
    if isGroup(self, PROJECT_GROUP):
        ProjectMaterial.objects.get_or_create(project = project,
                                              material = material,
                                              category = material.category,
                                              quantity = MAX_PROJECT_MATERIAL_QANTITY)
    else:
        ProjectMaterial.objects.get_or_create(project = project,
                                              material = material,
                                              category = material.category)