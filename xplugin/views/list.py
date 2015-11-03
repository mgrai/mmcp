import operator
from xadmin.util import get_fields_from_path, lookup_needs_distinct
from django.core.exceptions import SuspiciousOperation, ImproperlyConfigured, ValidationError
from django.db import models
from django.db.models.fields import FieldDoesNotExist
from django.db.models.related import RelatedObject
from django.db.models.sql.query import LOOKUP_SEP, QUERY_TERMS
from django.template import loader
from django import forms
from django.utils.encoding import smart_str
from django.utils.translation import ugettext as _
from xadmin.filters import manager as filter_manager, FILTER_PREFIX, SEARCH_VAR, DateFieldListFilter, RelatedFieldSearchFilter
from xadmin.views import ListAdminView
from xadmin.sites import site
from django.core.urlresolvers import reverse, NoReverseMatch
from xadmin.util import lookup_field, display_for_field, label_for_field, boolean_icon

class IncorrectLookupParameters(Exception):
    pass

FILTER_PREFIX = '_p_'
SEARCH_VAR = '_q_'


class MyListAdminView(ListAdminView):
    free_query_filter = True
    filter_specs = []
    list_filter = []
    list_editable = []
    
    show_my_detail_fields = []
    
    def get_media(self):
        media = forms.Media()
        media + self.vendor('xadmin.plugin.filters.js')
        
        if bool(filter(lambda s: isinstance(s, DateFieldListFilter), self.filter_specs)):
            media = media + self.vendor('datepicker.css', 'datepicker.js',
                                        'xadmin.widget.datetime.js')
        if bool(filter(lambda s: isinstance(s, RelatedFieldSearchFilter), self.filter_specs)):
            media = media + self.vendor(
                'select.js', 'select.css', 'xadmin.widget.select.js')
        
        if self.show_my_detail_fields:
            media = media + self.vendor('my.js', 'xadmin.form.css')
            
        
#         if self.editable_need_fields:
        media = media +  \
                self.vendor(
                    'xadmin.plugin.editable.js', 'xadmin.widget.editable.css')
    
        return media 
    
    def block_nav_menu(self, context, nodes):
        if self.has_filters:
            nodes.append(loader.render_to_string('xadmin/blocks/model_list.nav_menu.filters.html', context_instance=context))
            
    def block_nav_form(self, context, nodes):
        if self.search_fields:
            nodes.append(
                loader.render_to_string(
                    'xadmin/blocks/model_list.nav_form.search_form.html',
                    {'search_var': SEARCH_VAR,
                        'remove_search_url': self.get_query_string(remove=[SEARCH_VAR]),
                        'search_form_params': self.get_form_params(remove=[SEARCH_VAR])},
                    context_instance=context))
            
    def get_list_queryset(self):
        queryset = self.queryset()
           
        lookup_params = dict([(smart_str(k)[len(FILTER_PREFIX):], v) for k, v in self.params.items()
                              if smart_str(k).startswith(FILTER_PREFIX) and v != ''])
        for p_key, p_val in lookup_params.iteritems():
            if p_val == "False":
                lookup_params[p_key] = False
        use_distinct = False
   
        # for clean filters
        self.has_query_param = bool(lookup_params)
        self.clean_query_url = self.get_query_string(remove=
                                                                           [k for k in self.request.GET.keys() if k.startswith(FILTER_PREFIX)])
    
        # Normalize the types of keys
        if not self.free_query_filter:
            for key, value in lookup_params.items():
                if not self.lookup_allowed(key, value):
                    raise SuspiciousOperation(
                        "Filtering by %s not allowed" % key)
    
        self.filter_specs = []
        if self.list_filter:
            for list_filter in self.list_filter:
                if callable(list_filter):
                    # This is simply a custom list filter class.
                    spec = list_filter(self.request, lookup_params,
                                       self.model, self)
                else:
                    field_path = None
                    field_parts = []
                    if isinstance(list_filter, (tuple, list)):
                        # This is a custom FieldListFilter class for a given field.
                        field, field_list_filter_class = list_filter
                    else:
                        # This is simply a field name, so use the default
                        # FieldListFilter class that has been registered for
                        # the type of the given field.
                        field, field_list_filter_class = list_filter, filter_manager.create
                    if not isinstance(field, models.Field):
                        field_path = field
                        field_parts = get_fields_from_path(
                            self.model, field_path)
                        field = field_parts[-1]
                    spec = field_list_filter_class(
                        field, self.request, lookup_params,
                        self.model, self, field_path=field_path)
    
                    if len(field_parts)>1:
                        # Add related model name to title
                        spec.title = "%s %s"%(field_parts[-2].name,spec.title)
    
                    # Check if we need to use distinct()
                    use_distinct = (use_distinct or
                                    lookup_needs_distinct(self.opts, field_path))
                if spec and spec.has_output():
                    try:
                        new_qs = spec.do_filte(queryset)
                    except ValidationError, e:
                        new_qs = None
                        self.message_user(_("<b>Filtering error:</b> %s") % e.messages[0], 'error')
                    if new_qs is not None:
                        queryset = new_qs
    
                    self.filter_specs.append(spec)
    
        self.has_filters = bool(self.filter_specs)
        self.filter_specs = self.filter_specs
        self.used_filter_num = len(
            filter(lambda f: f.is_used, self.filter_specs))
    
        try:
            for key, value in lookup_params.items():
                use_distinct = (
                    use_distinct or lookup_needs_distinct(self.opts, key))
        except FieldDoesNotExist, e:
            raise IncorrectLookupParameters(e)
    
        try:
            queryset = queryset.filter(**lookup_params)
        except (SuspiciousOperation, ImproperlyConfigured):
            raise
        except Exception, e:
            raise IncorrectLookupParameters(e)
   
        query = self.request.GET.get(SEARCH_VAR, '')
   
        # Apply keyword searches.
        def construct_search(field_name):
            if field_name.startswith('^'):
                return "%s__istartswith" % field_name[1:]
            elif field_name.startswith('='):
                return "%s__iexact" % field_name[1:]
            elif field_name.startswith('@'):
                return "%s__search" % field_name[1:]
            else:
                return "%s__icontains" % field_name
   
        if self.search_fields and query:
            orm_lookups = [construct_search(str(search_field))
                           for search_field in self.search_fields]
            for bit in query.split():
                or_queries = [models.Q(**{orm_lookup: bit})
                              for orm_lookup in orm_lookups]
                queryset = queryset.filter(reduce(operator.or_, or_queries))
            if not use_distinct:
                for search_spec in orm_lookups:
                    if lookup_needs_distinct(self.opts, search_spec):
                        use_distinct = True
                        break
            self.search_query = query
   
        if use_distinct:
            return queryset.distinct()
        else:
            return queryset
    
    def result_item(self, obj, field_name, row):
        item = super(MyListAdminView, self).result_item(obj, field_name, row)
        if field_name in self.show_my_detail_fields and item.text:
            data = item.text
            item.text = ''
            text, attr = label_for_field(field_name, obj.__class__,
                                     model_admin=self,
                                     return_attr=True
                                     )
            title = text
            item.btns.append('<a data-content="%s" class="details-handler" rel="tooltip" title="%s"><i class="fa fa-info-circle"></i></a>'
                                         % (data, title))
        
        if self.list_editable and item.field and item.field.editable and (field_name in self.list_editable):            
            pk = getattr(obj, obj._meta.pk.attname)
            field_label = label_for_field(field_name, obj,
                                          model_admin=self,
                                          return_attr=False
                                          )

            item.wraps.insert(0, '<span class="editable-field">%s</span>')
            item.btns.append((
                '<a class="editable-handler" title="%s" data-editable-field="%s" data-editable-loadurl="%s">'+
                '<i class="fa fa-edit"></i></a>') %
                 (_(u"Enter %s") % field_label, field_name, self.model_admin_url('patch', pk) + '?fields=' + field_name))

#             if field_name not in self.editable_need_fields:
#                 self.editable_need_fields[field_name] = item.field
            
        return item
    