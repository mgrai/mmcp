# coding=utf-8

class AbstractObjectAdmin(object):
    
    reversion_enable = True
    
    @property
    def exclude(self):
        list = ['company']
        if self.user.is_superuser:
            list.remove('company')
        return list
    
    
    def save_models(self):
        if not self.user.is_superuser:
            self.new_obj.company = self.user.company
        return super(AbstractObjectAdmin, self).save_models()
    
    def queryset(self):
        if self.user.is_superuser:
            return super(AbstractObjectAdmin, self).queryset()
        else:   
            return super(AbstractObjectAdmin, self).queryset().filter(company=self.user.company)
