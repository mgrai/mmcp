# coding=utf-8
import time
from models import Route, Actor, ActorUser, Item, TaskList,TaskHistory,ITEM_REJECTED, ITEM_START,ITEM_APPROVING, APPROVED,REJECTED,REAPPLY, ITEM_APPROVED, ITEM_STATUS
from payment.models import Payment
from django.conf import settings
from mmcp.weixin import send_message
from document.models import *


def send_message_to_next_approval(actor, item): 
    user = ActorUser.objects.filter(actor=actor)[0].user
#             user_id = user.username
    #审批人
    user_id = 'wyj'
    message = u'来自' + str(item.user) + '的 ' + str(item.item_name) + ',请审批。' + '单号：' + str(item.document)
    send_message(user_id, message)
    
def send_message_that_approved(actor, item):
    user = ActorUser.objects.filter(actor=actor)[0].user
#     user_id = item.user.username
    user_id = 'wyj'
    message = str(user) + '已审批通过您的' + str(item.item_name) + '。单号：' + str(item.document)
    send_message(user_id, message)  
    
def send_messag_that_reject(actor, item):  
    user = ActorUser.objects.filter(actor=actor)[0].user
#     user_id = item.user.username
    user_id = 'wyj'
    message = str(user) + '拒绝了您的' + str(item.item_name) + '。单号：' + str(item.document)
    send_message(user_id, message)  
    

class Workflow():
    #项目申请
    def applyWorkflow(self, route, item, user):
        #查找所选流程的第一个步骤
        actor = Actor.objects.filter(route = route).order_by('sort_order')[0]
        #插入任务列表taskList
        TaskList.objects.get_or_create(item=item, actor=actor)
        #修改项目Item的状态为待审批
        item.status = ITEM_START
        item.save(update_fields=['status'])
        
        if settings.ENABLE_WEIXIN_MESSAGE:
            #发送信息给下一个审批人
            send_message_to_next_approval(actor, item)  
            
           
     
     
    #审批通过
    def approveWorkflow(self, item, user, comments):
        #find current task
        currentTask = TaskList.objects.filter(item = item)[0]
        currentActor = currentTask.actor
        actorUser = ActorUser.objects.filter(actor=currentActor)[0].user
        #重复提交
        if (user == actorUser):
            #find the last actor
            lastActor = Actor.objects.filter(route = currentTask.actor.route).order_by('-sort_order')[0]
            
            if currentActor != lastActor:
                #find the next actor
                nextActor = Actor.objects.filter(route = currentTask.actor.route).filter(sort_order__gt = currentTask.actor.sort_order).order_by('sort_order')[0]
                #update to next actor
                currentTask.actor = nextActor
                currentTask.save(update_fields=['actor'])
                #修改项目Item的状态为审批中
                item.status = ITEM_APPROVING
            else:
                #if the actor is last actor then update item to approved
                item.status = ITEM_APPROVED
                
            item.save(update_fields=['status'])     
            
            #插入任务历史记录
            TaskHistory.objects.create(item=item, actor=currentActor, 
                                       status=APPROVED, 
                                       user=user, comments=comments)
           
            if settings.ENABLE_WEIXIN_MESSAGE:
                #通知当前申请人
                send_message_that_approved(currentActor, item)
                
                if item.status == ITEM_APPROVING:
                    #通知下一个审批人
                    send_message_to_next_approval(nextActor, item) 
                
            
           
    
    #审批拒绝
    def rejectWorkflow(self, item, user, comments):
        #update任务列表的步骤ID为第一步的ID
        #find current task
        currentTask = TaskList.objects.filter(item = item)[0]
        currentActor = currentTask.actor
        firstActor = Actor.objects.filter(route = currentTask.actor.route).order_by('sort_order')[0]
        
        #update to first actor
        currentTask.actor = firstActor
        currentTask.save(update_fields=['actor'])
        
        #插入任务历史记录
        TaskHistory.objects.create(item=item, actor=currentActor, 
                                   status=REJECTED, 
                                   user=user, comments=comments)
        #修改项目Item的状态为审批中
        item.status = ITEM_REJECTED
        item.save(update_fields=['status'])
        
        if settings.ENABLE_WEIXIN_MESSAGE:
            send_messag_that_reject(currentActor, item)
            
        
        
        
    #重新发起申请
    def reApplyWorkflow(self, item, user, comments):
        #find current task
        currentTask = TaskList.objects.filter(item = item)[0]
        
        
        #插入任务历史记录
        TaskHistory.objects.create(item=item, 
                                   status=REAPPLY, 
                                   user=user, comments=comments)
        #修改项目Item的状态为待审批
        item.status = ITEM_START
        item.save(update_fields=['status'])
        
        if settings.ENABLE_WEIXIN_MESSAGE:
            #查找所选流程的第一个步骤
            actor = Actor.objects.filter(route = currentTask.actor.route).order_by('sort_order')[0]
        
            #发送信息给第一个审批人
            send_message_to_next_approval(actor, item)  

#我申请的Item     
def getMyApplayItems(self, route_name):
    if self.user.is_superuser:
        return Item.objects.filter(route__route_name = route_name) 
    else:
        return Item.objects.filter(user = self.user, route__route_name = route_name)
    
    
#待我处理的工作 
def getMyHandleItems(self, route_name):
    #找出当前步骤处理人
    actorUsers = ActorUser.objects.filter(user = self.user).select_related('actor')
    actors = []
    for actorUser in actorUsers:
        actors.append(actorUser.actor)
        
    tasks = TaskList.objects.filter(actor__in = actors).select_related('item')
    item_ids= []
    for task in tasks:
        item_ids.append(task.item.id)
    return Item.objects.filter(id__in=item_ids, status__in=(ITEM_START, ITEM_APPROVING), route__route_name = route_name)

#已处理的工作
def getMyHandledItems(self, route_name):
    histories = TaskHistory.objects.filter(user = self.user).select_related('item')
    item_ids= []
    for history in histories:
        item_ids.append(history.item.id)
    return Item.objects.filter(id__in=item_ids, route__route_name = route_name)
         

def getPayment(payment_id):
    payment = None
    payment_set = Payment.objects.filter(payment_id = payment_id)
    if payment_set.exists():
        payment = payment_set[0]   
    return payment 

def handlePayment(item):
        payment = getPayment(item.document.document_id)
        if payment is not None:
            if payment.applied_amount is None:
                payment.applied_amount = payment.payment_amount
                payment.save(update_fields=['applied_amount'])
                
def handleDocumentLine(item):
    lines = DocumentLineItem.objects.filter(document = item.document)
    for line in lines:
        if  line.audit_quantity is None:
                line.audit_quantity = line.expected_quantity
                line.save(update_fields=['audit_quantity'])
    

def hasApprovedBySelf(self, item):
    result = False
    #在审批中
    if item.status == 1 :
        queryset = TaskHistory.objects.filter(user = self.user, item = item, status = 1)
        if len(queryset) > 0:
            result = True
    
    return result
        
        
        
    