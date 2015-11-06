# coding=utf-8
from django.db import models
from project.models import Project, Company
from material.models import Vendor


class ProjectSetting(models.Model):
    class Meta:
        verbose_name = u'项目设置'
        verbose_name_plural = verbose_name

    project = models.ForeignKey(Project,verbose_name=u'所属项目')
    online_before_amount = models.DecimalField(u'上线前已采购金额',max_digits = 15, decimal_places=2, blank=True, null=True)

    def __unicode__(self):
        return self.project.name
    
class VendorSetting(models.Model):
    class Meta:
        ordering = ['vendor__id']
        verbose_name = u'供应商设置'
        verbose_name_plural = verbose_name

    vendor = models.ForeignKey(Vendor,verbose_name=u'供应商')
    company = models.ForeignKey(Company,verbose_name=u'公司')
    
    online_before_owed_amount = models.DecimalField(u'上线前欠款',max_digits = 15, decimal_places=2, blank=True, null=True)
    online_before_owed_invoice = models.DecimalField(u'上线前欠发票',max_digits = 15, decimal_places=2, blank=True, null=True)
    online_before_received_amount = models.DecimalField(u'上线前发生额',max_digits = 15, decimal_places=2, blank=True, null=True)
    
#     before_2015_2_owed_amount = models.DecimalField(u'2015年2月底前欠款',max_digits = 15, decimal_places=2, blank=True, null=True)
#     before_2015_2_owed_invoice = models.DecimalField(u'2015年2月底前欠发票',max_digits = 15, decimal_places=2, blank=True, null=True)
     
#     before_2015_2_received_amount = models.DecimalField(u'2015年2月底前发生额',max_digits = 15, decimal_places=2, blank=True, null=True)

    def __unicode__(self):
        return self.vendor.name
