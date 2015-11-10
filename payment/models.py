# coding=utf-8
from django.db import models
from material.models import Vendor
from project.models import Company
from company.models import *
from django.db.models import Q


class PaymentType(models.Model):
    name = models.CharField(u'支付方式',max_length=50)
    company = models.ForeignKey(Company,verbose_name=u'公司')
 
    def __unicode__(self):
        return self.name
 
    class Meta:
        verbose_name = u'支付方式'
        verbose_name_plural = verbose_name


class PaymentProperty(models.Model):
    name = models.CharField(u'款项属性',max_length=50)
    company = models.ForeignKey(Company,verbose_name=u'公司')
    
    def __unicode__(self):
        return self.name
 
    class Meta:
        verbose_name = u'款项属性'
        verbose_name_plural = verbose_name  
              
class Payment(models.Model):
    payment_id = models.CharField(u'付款单',max_length=50)
    company = models.ForeignKey(Company,verbose_name=u'公司')
    vendor = models.ForeignKey(Vendor,verbose_name=u'供应商')
    content = models.CharField(u'采购物资内容',max_length=100)
    payment_amount = models.DecimalField(u'付款金额',max_digits = 15, decimal_places=2)
    applied_amount = models.DecimalField(u'审批金额',max_digits = 15, decimal_places=2, blank=True, null=True)
    paymentType = models.ForeignKey(PaymentType,verbose_name=u'付款方式')
    paymentProperty = models.ForeignKey(PaymentProperty,verbose_name=u'款项属性')
    purchase_amount = models.DecimalField(u'采购金额',max_digits = 15, decimal_places=2, blank=True, null=True)
    owed_amount = models.DecimalField(u'现欠款额',max_digits = 15, decimal_places=2, blank=True, null=True)
    owed_amount_after_payment = models.DecimalField(u'本期支付后欠款额',max_digits = 15, decimal_places=2, blank=True, null=True)
    
    payment_user = models.ForeignKey(Employee, related_name='paymentGroup', verbose_name=u'付款经办人')
    purchase_user = models.ForeignKey(Employee, related_name='purchaseGroup', verbose_name=u'采购经手人', blank=True, null=True)
    create_time = models.DateField(u'付款申请日期', blank=True,null=True)
    payment_date = models.DateField(u'实际付款日期',  blank=True,null=True)
    
    comments  = models.TextField(u'备注',blank=True,null=True) 
    
    is_applied = models.BooleanField(u'已提交申请', default=False) 
    is_closed = models.BooleanField(u'已闭合', default=False) 
    
    
    
    def __unicode__(self):
        return self.payment_id
 
    class Meta:
        ordering = ["-payment_id"]
        verbose_name = u'付款'
        verbose_name_plural = verbose_name  
        
class DoPayemnt(Payment):
    
    class Meta:
        ordering = ["-payment_id"]
        verbose_name = u'付款'
        proxy = True                      