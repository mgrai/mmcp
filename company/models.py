# coding=utf-8
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.exceptions import ValidationError
from mptt.models import MPTTModel, TreeForeignKey


class Company(MPTTModel):
    class Meta:
        ordering = ['tree_id', 'lft', 'name', ]
        verbose_name = u'公司'
        verbose_name_plural = verbose_name
        
    class MPTTMeta:
        parent_attr = 'parent'
        
    parent = TreeForeignKey('self', null=True, verbose_name= u'公司总称', blank=True, related_name='children')
        
    name = models.CharField( u'名称',max_length=50)
    short_name  = models.CharField(u'简称',max_length=50)
    address  = models.CharField(u'地址',max_length=50)
    phone  = models.CharField(u'电话',max_length=50)
    fax  = models.CharField(u'传真',max_length=50)
    zip  = models.CharField(u'邮编',max_length=50)
 
    def __unicode__(self):
        return self.name
    
    def clean(self):
        if self.id is None:
            try:
                m = Company.objects.filter(name = self.name)[0]
            except IndexError:
                m = None  
            
            if m is not None:
                raise ValidationError('公司名称已存在，请增加其他公司名称！')
 

class Employee(AbstractUser):
    company = models.ForeignKey(Company, verbose_name= u'公司', blank=True, null=True)
    
    def __unicode__(self):
        return self.last_name + self.first_name
    
    
