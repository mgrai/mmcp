# coding=utf-8

from django.db import models
from django.core.exceptions import ValidationError
from django.db.models import Sum

from company.models import *
from project.models import *
from material.models import *
from mmcp.constant import *
from document_util import *


PROJECT_TYPE = 0
PAYMENT_TYPE = 1

DOCUMENT_TYPES = (
    (PROJECT_TYPE, u"项目材料申请单"),
    (PAYMENT_TYPE, u"付款申请单"),
)

    
class Document(models.Model):
    class Meta:
        verbose_name = u'单据'
        verbose_name_plural = verbose_name
        
    document_id = models.CharField(u'单据编号',max_length=50)
    document_type = models.SmallIntegerField(u'单据类型', choices=DOCUMENT_TYPES)
    user = models.ForeignKey(Employee,verbose_name=u'申请人')
    create_date = models.DateField(u'申请日期', blank=True,null=True)
    
    purch_status = models.CharField(u'采购状态',max_length=20, default = '未采购')
    
    project = models.ForeignKey(Project,verbose_name=u'项目', blank=True,null=True)
    
    def __unicode__(self):
        return self.document_id    
     
class DocumentLineItem(models.Model):  
    class Meta:
        ordering = ['-document__id',"projectMaterial__project__id", "projectMaterial__material__category__name", "projectMaterial__material__name"]
        verbose_name = u'单据名细'
        verbose_name_plural = verbose_name 
    
    document = models.ForeignKey(Document,verbose_name=u'单据编号')
    projectMaterial = models.ForeignKey(ProjectMaterial,verbose_name=u'项目材料')
    brand = models.ForeignKey(Brand,verbose_name=u'品牌', blank=True,null=True)
    
    expected_quantity = models.IntegerField(u'申请数量',blank=True,null=True) 
    posted_quantity = models.IntegerField(u'已到货数量',blank=True,null=True) 
    audit_quantity = models.IntegerField(u'审批数量',blank=True,null=True) 
    expected_date = models.DateField(u'申请到货日期',blank=True,null=True) 
    comments  = models.TextField(u'备注',blank=True,null=True) 
    approval_comments  = models.TextField(u'审批备注',blank=True,null=True) 
    file = models.FileField(u'附件', upload_to='.', blank=True)
    material = models.CharField(u'实际采购材料',max_length=250,  blank=True,null=True)
    
    def clean(self):
        if self.expected_quantity and self.projectMaterial and (self.material is None):
            #已采购数量
            avaiable_quantity = self.projectMaterial.quantity - getApprovedQuantity(self)
            if self.expected_quantity > avaiable_quantity:
                msg = '要求数量不能大于可用量'
                if avaiable_quantity <= 5:
                    msg += ', 可用量为' + str(avaiable_quantity)
                raise ValidationError(msg)
                
    def getProjectName(self):
        return self.projectMaterial.project.name
    getProjectName.short_description = u"项目名称"
    
    def getProjectMaterial(self):
        return self.projectMaterial.getMaterialName()
    getProjectMaterial.short_description = u"材料"
    
    def getMaterial(self):
        result = self.projectMaterial.material.name if self.projectMaterial.material.name else ''
        if self.material:
            name = self.material.split("-")
            if len(name) > 0:
                result = name[0]
        return result
    
    def getSpecification(self):
        result = self.projectMaterial.material.specification if self.projectMaterial.material.specification else ''
        if self.material:
            name = self.material.split("-")
            if len(name) > 1:
                result = name[1]
        return result
    
    def getUnit(self):
        result = self.projectMaterial.material.unit.name if self.projectMaterial.material.unit else ''
        if self.material:
            name = self.material.split("-")
            if len(name) > 2:
                result = name[2]
        return result

        
    
    def getQuantity(self):
        qunatity = ''
        if self.projectMaterial.quantity != MAX_PROJECT_MATERIAL_QANTITY:
            qunatity = self.projectMaterial.quantity
        return qunatity
    getQuantity.short_description = u"预算量"
    
    
    def __unicode__(self):
        return str(self.projectMaterial)

   
    