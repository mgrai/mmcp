# coding=utf-8

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
        result = GROUP_NAME == self.user.groups.all()[0].name
    return result 