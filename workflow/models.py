# coding=utf-8
from django.db import models
from django.contrib.auth.models import  Group
from document.models import Document
from company.models import *


ITEM_START = 0
ITEM_APPROVING = 1
ITEM_APPROVED = 2
ITEM_REJECTED = 3

ITEM_STATUS = (
    (ITEM_START, u"审批开始"),
    (ITEM_APPROVING, u"审批中"),
    (ITEM_APPROVED, u"审批完成"),
    (ITEM_REJECTED, u"审批不通过"),
)


REAPPLY = 0;
APPROVED = 1;
REJECTED = 2;

AUDIT_STATUS = (
    (APPROVED, u"审批通过"),
    (REJECTED, u"审批不通过"),           
)

AUDIT_HISTORY_STATUS = (
    (REAPPLY, u"重新发起审批"),
    (APPROVED, u"审批通过"),
    (REJECTED, u"审批不通过"),           
)

PAYMENT_ROUTE = u'付款申请'
PROJECT_ROUTE = u'项目材料申请'

class Route(models.Model):
    class Meta:
        verbose_name = u'流程'
        verbose_name_plural = verbose_name

    route_name  = models.CharField(u'流程描述',max_length=20)
    group = models.ForeignKey(Group,verbose_name=u'所属部门',blank=True,null=True)
    
    
    def __unicode__(self):
        return self.route_name 
    
class Actor(models.Model):
    class Meta:
        ordering = ["route__id", "sort_order"]
        verbose_name = u'步骤'
        verbose_name_plural = verbose_name

    route = models.ForeignKey(Route,verbose_name=u'所属流程',blank=True,null=True)
    actor_name  = models.CharField(u'步骤描述',max_length=20)
    sort_order  = models.IntegerField(u'步骤序号')
    
    def __unicode__(self):
        return self.route.route_name + " - " +self.actor_name 
    
         

class ActorUser(models.Model):
    class Meta:
        ordering = ["actor__route__id", "actor__sort_order"]
        verbose_name = u'步骤处理人'
        verbose_name_plural = verbose_name

    actor = models.ForeignKey(Actor,verbose_name=u'步骤',blank=True,null=True)
    user = models.ForeignKey(Employee,verbose_name=u'处理人',blank=True,null=True)
    
    
    def __unicode__(self):
        return self.id  
    
class Item(models.Model):
    class Meta:
        ordering = ["-document__document_id"]
        verbose_name = u'项目申请'
        verbose_name_plural = verbose_name

    document = models.ForeignKey(Document,verbose_name=u'单据编号')
    
    item_name  = models.CharField(u'项目描述',max_length=50)
    route = models.ForeignKey(Route,verbose_name=u'所属流程',blank=True,null=True)
    user = models.ForeignKey(Employee,verbose_name=u'项目申请人',blank=True,null=True)
    status = models.SmallIntegerField(u'状态', choices=ITEM_STATUS,blank=True,null=True)
    
    

    def __unicode__(self):
        return self.document.document_id     
    
class TaskList(models.Model):
    class Meta:
        verbose_name = u'任务列表'
        verbose_name_plural = verbose_name

    item = models.ForeignKey(Item,verbose_name=u'项目',blank=True,null=True)
    actor = models.ForeignKey(Actor,verbose_name=u'步骤',blank=True,null=True)
    
    def __unicode__(self):
        return self.id  
      
class TaskHistory(models.Model):
    class Meta:
        ordering = ["item","create_date"]
        verbose_name = u'审核日志'
        verbose_name_plural = verbose_name

    item = models.ForeignKey(Item,verbose_name=u'项目',blank=True,null=True)
    actor = models.ForeignKey(Actor,verbose_name=u'步骤',blank=True,null=True)
    status = models.SmallIntegerField(u'状态', choices=AUDIT_HISTORY_STATUS)
    user = models.ForeignKey(Employee,verbose_name=u'审批人',blank=True,null=True)
    create_date = models.DateTimeField(u'审批时间', auto_now=True)
    comments = models.TextField(u'意见')
    
    def __unicode__(self):
        return self.status  
        

