# coding=utf-8
from django.db import models
from mptt.models import MPTTModel, TreeForeignKey
from django.core.exceptions import ValidationError
from company.models import *

class Category(models.Model):
    name = models.CharField(u'类别名称',max_length=50)
 
    def __unicode__(self):
        return self.name
 
    class Meta:
        verbose_name = u'类别'
        verbose_name_plural = verbose_name

class Specification(models.Model):
    name = models.CharField(u'规格名称',max_length=250)
 
    def __unicode__(self):
        return self.name
 
    class Meta:
        verbose_name = u'规格'
        verbose_name_plural = verbose_name 

class Unit(models.Model):
    name = models.CharField(u'单位名称',max_length=20)
 
    def __unicode__(self):
        return self.name
 
    class Meta:
        verbose_name = u'单位'
        verbose_name_plural = verbose_name          

class Material(models.Model):
    name = models.CharField(u'材料名称',max_length=50)
    alias = models.CharField(u'材料别名',max_length=150, blank=True,null=True)
    
    category = models.ForeignKey(Category,verbose_name=u'类别',blank=True,null=True)
    specification = models.CharField(u'规格',max_length=250 ,blank=True,null=True)
    unit = models.ForeignKey(Unit,verbose_name=u'单位',blank=True,null=True)
    
#     def clean(self):
#         try:
#             m = Material.objects.filter(name = self.name, category = self.category, specification = self.specification, unit = self.unit)[0]
#         except IndexError:
#             m = None  
#         
#         if m is not None:
#             raise ValidationError('材料名称已存在，请增加其他材料名称！')
        
    def getName(self):
        full_name = self.name
        
        if self.specification:
            full_name += " - " + self.specification
            
        if self.unit:
            full_name += " - " + self.unit.name
            
        return full_name
 
    def __unicode__(self):
        return self.getName()
 
    class Meta:
        ordering = ['category__id', 'name', 'specification']
        verbose_name = u'材料'
        verbose_name_plural = verbose_name

class Brand(models.Model):
    name = models.CharField(u'名称',max_length=50)
    def __unicode__(self):
        return self.name
    class Meta:
        verbose_name = u'品牌'
        verbose_name_plural = verbose_name

class Vendor(MPTTModel):
    class Meta:
        ordering = ['category__id', 'tree_id', 'lft']
        verbose_name = u'供应商'
        verbose_name_plural = verbose_name
    
    class MPTTMeta:
        parent_attr = 'parent'
    
    parent = TreeForeignKey('self', null=True, verbose_name= u'供应商总称', blank=True, related_name='children')
    
    name  = models.CharField(u'供应商名称',max_length=50)
    short_name  = models.CharField(u'供应商简称',max_length=50,blank=True,null=True)
    category = models.ForeignKey(Category,verbose_name=u'类别',blank=True,null=True)
    
    company = models.ForeignKey(Company,verbose_name=u'建筑企业',blank=True,null=True)
    
    contact  = models.CharField(u'联系人',max_length=50,blank=True,null=True)
    cellphone  = models.CharField(u'手机',max_length=50,blank=True,null=True)
    telephone  = models.CharField(u'电话',max_length=50,blank=True,null=True)
    
    fax  = models.CharField(u'传真',max_length=50,blank=True,null=True)
    email  = models.EmailField(u'邮箱',blank=True,null=True)
    address  = models.CharField(u'地址',max_length=50,blank=True,null=True)
    website  = models.URLField(u'网址',max_length=50,blank=True,null=True)
    
    bank  = models.CharField(u'开户行',max_length=50,blank=True,null=True)
    account  = models.CharField(u'帐号',max_length=50,blank=True,null=True)
    
    business_area  = models.TextField(u'业务范围',blank=True,null=True)
    comments  = models.TextField(u'备注',blank=True,null=True)
    
    def clean(self):
        if self.id is None:
            try:
                m = Vendor.objects.filter(name = self.name)[0]
            except IndexError:
                m = None  
            
            if m is not None:
                raise ValidationError('该供应商名称已存在，请增加其他供应商！')

    def __unicode__(self):
        return self.name            