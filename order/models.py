# coding=utf-8
from django.db import models
from document.models import Document, DocumentLineItem
from project.models import Company, Project
from material.models import Vendor, Brand
from django.db.models import Sum
from django.core.exceptions import ValidationError
from django.core.exceptions import ObjectDoesNotExist
from mmcp.constant import MAX_PROJECT_MATERIAL_QANTITY
from company.models import *


class OrderNote(models.Model):
    class Meta:
        verbose_name = u'采购单注意事项'
        verbose_name_plural = verbose_name
    name = models.CharField(u'名称',max_length=50)   
    note = models.TextField(u'内容')
    company = models.ForeignKey(Company,verbose_name=u'公司')
    
    def __unicode__(self):
        return self.name
    
class Order(models.Model):
    class Meta:
        ordering = ['-create_time']
        verbose_name = u'采购单'
        verbose_name_plural = verbose_name
        
    order_id = models.CharField(u'采购单',max_length=50)
    document = models.ForeignKey(Document,verbose_name=u'项目申请单')
    company = models.ForeignKey(Company,verbose_name=u'公司')
    project = models.ForeignKey(Project,verbose_name=u'项目')
    vendor = models.ForeignKey(Vendor,verbose_name=u'供应商', blank=True, null=True)
    create_time = models.DateField(u'订购日期', auto_now=True)
    note = models.ForeignKey(OrderNote,verbose_name=u'注意事项',blank=True, null=True)
    is_closed = models.BooleanField(u'闭合', default=False)
    
    user = models.ForeignKey(Employee,verbose_name=u'采购人', limit_choices_to = {'groups__name' : u'采购部门'}, blank=True, null=True)
    
    def __unicode__(self):
        return self.order_id
    
    
class OrderLine(models.Model):
    class Meta:
        verbose_name = u'采购单名细'
        ordering = ['-documentLineItem__document__id',"documentLineItem__projectMaterial__project__id", 
                    "documentLineItem__projectMaterial__material__category__name", 
                    "documentLineItem__projectMaterial__material__name",
                    "documentLineItem__projectMaterial__material__specification"]
        
        verbose_name_plural = verbose_name
        
    order = models.ForeignKey(Order,verbose_name=u'采购单')
    documentLineItem = models.ForeignKey(DocumentLineItem, verbose_name=u'项目材料')
    price = models.DecimalField(u'含税单价',max_digits = 15, decimal_places=2, blank=True, null=True)
    expected_date = models.DateField(u'要求到货日期',blank=True,null=True)  
    purchase_quantity = models.IntegerField(u'采购数量',blank=True,null=True)
    total = models.DecimalField(u'金额',max_digits = 15, decimal_places=2, blank=True, null=True)
    
    brand = models.ForeignKey(Brand,verbose_name=u'品牌', blank=True,null=True)
    
    def save(self, *args, **kwargs):
        self.total = (self.purchase_quantity or 0) * (self.price or 0)
        super(OrderLine, self).save()
        self.update_document_purch_status()
    
    def update_document_purch_status(self):
        #if self.documentLineItem.document.purch_status != '采购完成':
            status = self.getPurchasedStatus(self.documentLineItem.document)
            self.documentLineItem.document.purch_status = status
            self.documentLineItem.document.save(update_fields=['purch_status'])
    
    
    def getPurchasedStatus(self, document):
        documentLines = DocumentLineItem.objects.filter(document = document)
        status = '未采购'
        count = 0
        non_purchased_count = 0
        for documentLineItem in documentLines:
            #审批数量 为0 表示不用采购，当前状态为 采购完成
            if documentLineItem.audit_quantity == 0:
                count +=1
                non_purchased_count += 1
                continue
            
            #申请数量 为0 表示不用采购，当前状态为 采购完成
            if documentLineItem.expected_quantity is None or documentLineItem.expected_quantity == 0:
                count +=1
                non_purchased_count += 1
                continue
            
            quantity = self.getPurchasedQuantity(documentLineItem)
            if bool(quantity) and quantity > 0:
                #要求数量
                available_quantity = documentLineItem.expected_quantity
                
                #审批数量
                if documentLineItem.audit_quantity and documentLineItem.audit_quantity > 0:
                    available_quantity = documentLineItem.audit_quantity
                
                if available_quantity == quantity:
                    count += 1
                        
                #采购没有完成
                elif quantity < available_quantity:
                    status = '采购中'
                    break
            else:
                non_purchased_count += 1

            
        if count == len(documentLines):
            status = '采购完成' 
        elif count < len(documentLines) and count > 0:   
            status = '采购中' 
            
        if non_purchased_count == len(documentLines):
            status = '未采购'
        return status
    
    def getPurchasedQuantity(self, documentLineItem):
        total_quantity = OrderLine.objects.filter(documentLineItem__id = documentLineItem.id).aggregate(Sum('purchase_quantity'))
        return total_quantity['purchase_quantity__sum'] if total_quantity['purchase_quantity__sum'] is not None else ''        
        
            
    def __unicode__(self):
        return self.order.order_id + ' - ' + self.getProjectName() + ' - ' + self.getProjectMaterial() + ' - ' + str(self.purchase_quantity)
    
    
    def getProjectName(self):
        return self.order.project.name
    getProjectName.short_description = u"项目名称"
     
    def getProjectMaterial(self):
        material_name = self.documentLineItem.projectMaterial.getMaterialName()
        #实际采购材料
        if self.documentLineItem.material:
            material_name = self.documentLineItem.getMaterial()
            specification = self.documentLineItem.getSpecification()
            unit = self.documentLineItem.getUnit()
            if bool(specification):
                material_name += " - " + specification
            if bool(unit):
                material_name += " - " + unit    
        return material_name
    getProjectMaterial.short_description = u"材料"
    
    def getQuantity(self):
        qunatity = ''
        if self.documentLineItem.projectMaterial.quantity != MAX_PROJECT_MATERIAL_QANTITY:
            qunatity = self.documentLineItem.projectMaterial.quantity
        return qunatity
    
    getQuantity.short_description = u"预算量"
    
    def getExpectedQuantity(self):
        return self.documentLineItem.expected_quantity
    getExpectedQuantity.short_description = u"要求量"
    
    def getAuditQuantity(self):
        return (self.documentLineItem.audit_quantity or '')
    getAuditQuantity.short_description = u"审批量"
    
    def getComments(self):
        return self.documentLineItem.comments or ''
    getComments.short_description = u"备注"
    
    def getPostedQuantity(self):
        total_quantity = ReceivingLine.objects.filter(orderLine = self, receiving_date__isnull=False).aggregate(Sum('receiving_quantity'))
        return (total_quantity['receiving_quantity__sum'] or 0)
    getPostedQuantity.short_description = u"已到货量"
    
    def getTotalPurchasedQuantity(self):
        if self.id :
            total_quantity = OrderLine.objects.filter(documentLineItem__id = self.documentLineItem.id).exclude(id = self.id).aggregate(Sum('purchase_quantity'))
        else:
            total_quantity = OrderLine.objects.filter(documentLineItem__id = self.documentLineItem.id).aggregate(Sum('purchase_quantity'))
        return (total_quantity['purchase_quantity__sum'] or '')
    getTotalPurchasedQuantity.short_description = u"已采购量"
    
#     def getExpectedDate(self):
#         return self.documentLineItem.expected_date
#     getExpectedDate.short_description = u"交货日期"
    
    def getMaxPrice(self):
        max_price = self.documentLineItem.projectMaterial.price or 0
        if self.documentLineItem.projectMaterial.max_price > 0:
            max_price = self.documentLineItem.projectMaterial.max_price
        return max_price
    getExpectedQuantity.short_description = u"最大限价"
    
    
    def clean(self):
            #要求数量
            available_quantity = self.getExpectedQuantity()
            
            #审批数量
            if self.getAuditQuantity() != '':
                available_quantity = self.getAuditQuantity()
                
            #已采购量    
            totalPurchasedQuantity = self.getTotalPurchasedQuantity()
            if totalPurchasedQuantity != '':
                available_quantity = available_quantity - totalPurchasedQuantity
            
            if available_quantity == 0:
                raise ValidationError('该材料已采购完成不能再采购！')
            
            #退货排除
            if available_quantity > 0 and self.purchase_quantity > available_quantity:
                raise ValidationError('采购数量不能大于  %s' %available_quantity)
            
            #限价检查
            max_price = self.getMaxPrice()
            if self.price > max_price:
                raise ValidationError('单价不能大于最大限价')
            
            
            
        
class CheckAccount(models.Model):
    class Meta:
        ordering = ['-create_time']
        verbose_name = u'对账单'
        verbose_name_plural = verbose_name 
        
    check_account_id = models.CharField(u'对账单',max_length=50)    
    create_time = models.DateField(u'对帐日期', auto_now=True)
    
    start_date = models.DateField(u'开始日期', blank=True,null=True)
    end_date = models.DateField(u'结束日期', blank=True,null=True)
    vendor = models.ForeignKey(Vendor,verbose_name=u'供应商', blank=True, null=True)
    company = models.ForeignKey(Company,verbose_name=u'公司',  blank=True, null=True)
    
    def __unicode__(self):
        return self.check_account_id 
    
                
class ReceivingLine(models.Model):
    class Meta:
        verbose_name = u'到货单名细'
        verbose_name_plural = verbose_name 
    
    orderLine = models.ForeignKey(OrderLine,verbose_name=u'采购单名细') 
    receiving_quantity = models.DecimalField(u'到货数量', max_digits = 15, decimal_places=2)  
    #只作更新用不作其他用途
    original_receiving_quantity = models.DecimalField(u'前次到货数量', max_digits = 15, decimal_places=2, blank=True,null=True)  
    receiving_date = models.DateField(u'到货日期',blank=True,null=True)
    total = models.DecimalField(u'金额',max_digits = 15, decimal_places=2, blank=True, null=True)
    checkAccount = models.ForeignKey(CheckAccount,verbose_name=u'对账单', blank=True, null=True, on_delete=models.SET_NULL)
    
    comments  = models.TextField(u'备注',blank=True,null=True) 
    
    
    def clean(self):
        try:
            #采购数量
            purchase_quantity = self.getPurchaseQuantity()
            received_quantity = self.getTotalReceivedQuantity()
            available_quantity = purchase_quantity - received_quantity
            
            if available_quantity == 0:
                raise ValidationError('该材料已全部到货，不能再增加到货数量！')
            
            if purchase_quantity > 0 and self.receiving_quantity > available_quantity:
                raise ValidationError('到货数量不能大于  %s' %available_quantity)
        except ObjectDoesNotExist:
            pass
        
    def save(self, *args, **kwargs):
        #更新总的金额
        self.total = (self.receiving_quantity or 0) * (self.orderLine.price or 0)
        #更新已到货量
        quantity = (self.orderLine.documentLineItem.posted_quantity or 0)
        
        receiving_quantity = (self.receiving_quantity or 0) - (self.original_receiving_quantity or 0)
        
        self.orderLine.documentLineItem.posted_quantity = receiving_quantity + quantity
        self.orderLine.documentLineItem.save(update_fields=['posted_quantity'])
        self.original_receiving_quantity = self.receiving_quantity
        super(ReceivingLine, self).save() 
    
    
    def getOrderId(self):
        return self.orderLine.order.order_id
    getOrderId.short_description = "采购单"
    
    def getProjectName(self):
        return self.orderLine.order.project.name
    getProjectName.short_description = "项目名称"
    
    def getProjectMaterialName(self):
        material_name = self.orderLine.getProjectMaterial()
        return material_name
    getProjectMaterialName.short_description = "材料"
    
    def getPurchaseQuantity(self):
        return self.orderLine.purchase_quantity
    getPurchaseQuantity.short_description = "采购数量"
    
    def getTotalReceivedQuantity(self):
        total_quantity = ReceivingLine.objects.filter(orderLine = self.orderLine).exclude(id = self.id).aggregate(Sum('receiving_quantity'))
        return (total_quantity['receiving_quantity__sum'] or 0)
    getTotalReceivedQuantity.short_description = "已到货数量"
    
    def getPrice(self):
        return "%.2f" % (self.orderLine.price or 0)
    getPrice.short_description = "单价"
    
    def getCheckAccountId(self):
        return self.checkAccount.check_account_id
    getCheckAccountId.short_description = "对账单"
    
    
    def __unicode__(self):
        return u'到货单名细' 
    
class CheckAccountDetail(ReceivingLine):
    class Meta:
        ordering = ['-checkAccount__create_time', 'id']
        verbose_name = u'对账单名细'
        proxy = True    

INVOICE_TYPES = (
    (1, u"普通发票"),
    (2, u"增值税"),
)

class Invoice(models.Model):
    vendor = models.ForeignKey(Vendor,verbose_name=u'供应商')
    company = models.ForeignKey(Company,verbose_name=u'公司')
    invoice_number = models.CharField(u'发票号码',max_length=50)
    amount = models.DecimalField(u'金额',max_digits = 15, decimal_places=2)
    invoice_type = models.SmallIntegerField(u'发票类型', choices=INVOICE_TYPES)
    user = models.ForeignKey(Employee,verbose_name=u'经手人')
    date = models.DateField(u'发票日期')
    receive_date = models.DateField(u'收票日期', blank=True,null=True)
#     checkAccounts = models.ManyToManyField(CheckAccount,verbose_name=u'对帐单', blank=True, null=True)
    # for account to receive
    is_received = models.BooleanField(u'确认收票', default=False)
    
    def __unicode__(self):
        return self.invoice_number
 
    class Meta:
        verbose_name = u'发票'
        verbose_name_plural = verbose_name 
    
  
