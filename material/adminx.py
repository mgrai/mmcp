# coding=utf-8
import xadmin
from xadmin.plugins.batch import BatchChangeAction
from xadmin.plugins.actions import DeleteSelectedAction
from xadmin.views.base import CommAdminView 
from xadmin.adminx import AbstractObjectAdmin
from django.template.response import TemplateResponse
from django.http import HttpResponse, HttpResponseRedirect
from django.db.models import Q
from material.models import *
from mmcp.util import *
from mmcp.actions import *

class CategoryAdmin(object):
    show_bookmarks = False
    list_display = ('name',)
    list_display_links = ('name',)

    search_fields = ['name']

    actions = [BatchChangeAction, ]
    batch_fields = ('name',)
    
class SpecificationAdmin(object):
    show_bookmarks = False
    hidden_menu = True
    list_display = ('name',)
    list_display_links = ('name',)

    search_fields = ['name']

    actions = [BatchChangeAction, ]
    batch_fields = ('name',)
    
class UnitAdmin(object):
    show_bookmarks = False
    list_display = ('name',)
    list_display_links = ('name',)

    search_fields = ['name']

    actions = [BatchChangeAction, ]
    batch_fields = ('name',)  

class MaterialAdmin(object):
        
    def block_after_fieldsets(self, context, node):
        path = self.request.get_full_path()
        if path.find('add') != -1:
                inputHtml = """
                <div class="panel panel-default formset fieldset  stacked" id="specification_set-group">
                <div class="panel-heading">
                <i class="icon fa fa-chevron-up chevron"></i>
                <h3 class="panel-title">
                <a class="add-row" id="specification_set-add-row" href="javascript:void(0)"><i class="icon fa fa-plus"></i></a> 
                                                   其他规格
                </h3>
                </div>
                
                <div class="form-container row clearfix">
                <div id="specification_set" class="formColumn column form-column full col col-sm-12 form-horizontal ui-sortable" horizontal="True" span="12">
                
                <div id="id_panel-body" class="panel-body ">
                
                </div>
                
                </div>
                </div>
                </div>
                
                 <script>
                     $(document).ready(function(){                 
                        //增加<tr/>
                        $("#specification_set-add-row").click(function(){
                        
                            var _len = $("div[id^='div_id_specification']").length;            
                            
                            var id = 'div_id_specification-' + _len;
                            var input_id = 'id_specification_name-' + _len;
                            var name = 'specification_name-' + _len;
                            
                            $("#id_panel-body").append(
                                  "<div id=" + id + " class='form-group'>"
                                + "<label for='id_specification' class='control-label '>规格</label>"
                                + "<div class='controls '><a href='#' class='btn btn-primary btn-sm btn-ajax pull-right' onclick='removeNote("+_len+");return false;' ><i class='fa fa-times'></i></a>"
                                +   "<input class='text-field admintextinputwidget form-control' id=" + input_id + " maxlength='250' name="+ name +" type='text'>"
                                + "</div>"
                                + "</div>"
                            );                    
                        })           
                    })
                    
                    function removeNote(index)
                   {                                
                      $("#div_id_specification-"+index).remove();//删除当前行                        
                   }       
                </script>
                
                        """
                return inputHtml
        
    def getSpecificationNames(self):
        names = []
        result = []
        for key in self.request.POST.keys():
            if 'specification_name-' in key or 'specification' in key:
                names.append(key)
        if len(names) > 0:
            for name in names:
                result.append(self.request.POST[name])
             
        return result
            
        
    def save_models(self):
         
        names = self.getSpecificationNames()
        if len(names) > 0:
            for name in names:                
                material = Material.objects.get_or_create(name = self.new_obj.name,
                                               category = self.new_obj.category,
                                               unit = self.new_obj.unit,
                                               specification = name,
                                               alias = self.new_obj.alias)
                #分配该材料到项目中
                if 'project_id' in self.request.GET and material[1]:
                    project_id = self.request.GET['project_id']
                    assign_material_to_project(self, project_id, material[0])
                     
                     
                     
        else:
            super(MaterialAdmin, self).save_models()
            
        
    def post(self, request, *args, **kwargs):
        response = super(MaterialAdmin, self).post(request, *args, **kwargs)
        #材料保存后 页面返回到项目材料的页面
        if 'project_id' in self.request.GET and '_save' in self.request.POST:
            project_id = self.request.GET['project_id']
            url = "/project/projectmaterial/?_rel_project__id__exact=%s&batch_add=1" % (project_id)
            return HttpResponseRedirect(url)
        return response
            
        
                
        
    @property
    def actions(self):
        actions = [DeleteSelectedAction]
        if "project_id" in self.request.GET:
            actions.append(MaterialSelectedAction)
        return actions
    
    
    def get_context(self):
        context = super(MaterialAdmin, self).get_context()
        
        if not self.user.is_superuser:
            context['has_delete_permission']= False
        
        if 'project_id' in self.request.GET:
            project_id = self.request.GET['project_id']
            context['add_url']= '/material/material/add/?project_id=%s' %project_id
        return context
                    
    show_bookmarks = False
    list_display = ('name', 'alias', 'specification', 'unit')
    list_editable = ['name', 'alias', 'specification', 'unit']
    list_display_links = ('none',)
    list_filter = ['category',]

    search_fields = ['name', 'alias', 'specification']
    
    batch_fields = ('name',) 
    
class BrandAdmin(object):
    show_bookmarks = False
    list_display = ('name',)
    list_display_links = ('name',)

    search_fields = ['name']

    actions = [BatchChangeAction, ]
    batch_fields = ('name',)  
    
class VendorAdmin(AbstractObjectAdmin):
    def open_website(self, instance):
        return "<a href='%s' target='_blank'>%s</a>" % (instance.website,instance.website )
    open_website.short_description = "网址"
    open_website.allow_tags = True
    open_website.is_column = True
    
    def get_ordering(self):
        return ['category__id', 'tree_id', 'lft', ]
    
    list_display = ('name', 'short_name','category', 'contact', 'cellphone', 'telephone', 'fax', 'email', 'open_website', 'comments')
    list_editable = ['short_name',]
    list_display_links = ('name',)
    list_filter = ['category', ]
    exclude = ['company',]

    search_fields = ['name']

    actions = [BatchChangeAction, ]
    batch_fields = ('name',)
    


class MaterialPriceView(CommAdminView):
    need_site_permission = True
    list_template = 'views/material_price.html'
    
    def get(self, request, *args, **kwargs):
        context = super(MaterialPriceView, self).get_context()
        
        return TemplateResponse(request, self.list_template, context,
                                current_app=self.admin_site.name)
    
    def post(self, request, *args, **kwargs):
        material_name = ''
        if 'material_name' in request.POST:
            material_name = request.POST['material_name']
            
        specification = ''
        if 'specification' in request.POST:
            specification = request.POST['specification']
             
        response = self.get(request)
        context = response.context_data
        
        result = get_material_price(material_name, specification) 
        if len(result['lines']) == 0:
            result['message'] ='没有查询到结果！' 
         
        context['result'] = result
        return response         

def get_material_price(material_name, specification):
    args_list = [] 
     
    if material_name:
        args_list.append(Q(documentLineItem__projectMaterial__material__name__contains = material_name)) 
    if specification:
        args_list.append(Q(documentLineItem__projectMaterial__material__specification__contains = specification))
         
    args = Q() 
    for each_args in args_list :
        args = args & each_args
         
    queryset = OrderLine.objects.filter(*(args,)) \
                                        .order_by('documentLineItem__projectMaterial__material__category__id',
                                                  'documentLineItem__projectMaterial__material__name',
                                                  'documentLineItem__projectMaterial__material__specification')
    lines = []
    for orderLine in queryset:
        line = {}
        line['price'] = orderLine.price
        line['vendor'] = orderLine.order.vendor.name if orderLine.order.vendor else ''
        line['project'] = orderLine.getProjectName()
        line['material'] = orderLine.getProjectMaterial()
        lines.append(line)
     
    result = {}
    result["lines"] =  lines
    result["material_name"] =  material_name
    result["specification"] =  specification
    return result
    
xadmin.site.register(Category, CategoryAdmin)  
xadmin.site.register(Specification, SpecificationAdmin)  
xadmin.site.register(Unit, UnitAdmin)            
xadmin.site.register(Material, MaterialAdmin)            
xadmin.site.register(Brand, BrandAdmin)            
xadmin.site.register(Vendor, VendorAdmin)     
xadmin.site.register_view(r"^material/price/$", MaterialPriceView, name='material/price')       
