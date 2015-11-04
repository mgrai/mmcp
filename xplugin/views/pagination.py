from xadmin.views.base import CommAdminView , ModelAdminView, inclusion_tag
from django.template.response import SimpleTemplateResponse, TemplateResponse
from django.utils.translation import ugettext_lazy as _
from django.core.paginator import InvalidPage, Paginator
from django.utils.safestring import mark_safe
from django.utils.html import escape, conditional_escape
from django.http import HttpResponseRedirect

# List settings
ALL_VAR = 'all'
ORDER_VAR = 'o'
PAGE_VAR = 'p'
TO_FIELD_VAR = 't'
COL_LIST_VAR = '_cols'
ERROR_FLAG = 'e'

DOT = '.'

class MyPaginationView(CommAdminView):
    list_per_page = 50
    list_max_show_all = 200
    paginator_class = Paginator
    paginator = None
    page_num = 0
    multi_page = False
    can_show_all = False
    show_all = False
    
    
    def getMyQueryset(self):
        return None
    
    def get_context(self):
        new_context = {
            'cl': self,
            'results': self.result_list
        }
        context = super(MyPaginationView, self).get_context()
        context.update(new_context)
        return context
    
    def init_paginator(self):
        self.paginator = self.get_paginator(self.getMyQueryset())
        self.result_count = self.paginator.count
        
        self.full_result_count = self.getMyQueryset().count
        
        self.can_show_all = self.result_count <= self.list_max_show_all
        self.multi_page = self.result_count > self.list_per_page
        
        # Get the list of objects to display on this page.
        if (self.show_all and self.can_show_all) or not self.multi_page:
            self.result_list = self.getMyQueryset()._clone()
        else:
            try:
                self.result_list = self.paginator.page(
                    self.page_num + 1).object_list
            except InvalidPage:
                if ERROR_FLAG in self.request.GET.keys():
                    return SimpleTemplateResponse('xadmin/views/invalid_setup.html', {
                        'title': _('Database error'),
                    })
                return HttpResponseRedirect(self.request.path + '?' + ERROR_FLAG + '=1')
        self.has_more = self.result_count > (
            self.list_per_page * self.page_num + len(self.result_list))
         
    
    def init_request(self, *args, **kwargs):
        request = self.request
        
        # Get page number parameters from the query string.
        try:
            self.page_num = int(request.GET.get(PAGE_VAR, 0))
        except ValueError:
            self.page_num = 0

        # Get params from request
        self.show_all = ALL_VAR in request.GET
#         self.to_field = request.GET.get(TO_FIELD_VAR)
        self.params = dict(request.GET.items())

        if PAGE_VAR in self.params:
            del self.params[PAGE_VAR]
        if ERROR_FLAG in self.params:
            del self.params[ERROR_FLAG]
            
        self.init_paginator()
    
    
    def get_paginator(self, queryset):
        return self.paginator_class(queryset, self.list_per_page, 0, True)
    
    def get_page_number(self, i):
        if i == DOT:
            return mark_safe(u'<span class="dot-page">...</span> ')
        elif i == self.page_num:
            return mark_safe(u'<span class="this-page">%d</span> ' % (i + 1))
        else:
            return mark_safe(u'<a href="%s"%s>%d</a> ' % (escape(self.get_query_string({PAGE_VAR: i})), (i == self.paginator.num_pages - 1 and ' class="end"' or ''), i + 1))

    
    
    @inclusion_tag('xadmin/includes/pagination.html')
    def block_pagination(self, context, nodes, page_type='normal'):
        """
        Generates the series of links to the pages in a paginated list.
        """
        paginator, page_num = self.paginator, self.page_num

        pagination_required = (
            not self.show_all or not self.can_show_all) and self.multi_page
        if not pagination_required:
            page_range = []
        else:
            ON_EACH_SIDE = {'normal': 5, 'small': 3}.get(page_type, 3)
            ON_ENDS = 2

            # If there are 10 or fewer pages, display links to every page.
            # Otherwise, do some fancy
            if paginator.num_pages <= 10:
                page_range = range(paginator.num_pages)
            else:
                # Insert "smart" pagination links, so that there are always ON_ENDS
                # links at either end of the list of pages, and there are always
                # ON_EACH_SIDE links at either end of the "current page" link.
                page_range = []
                if page_num > (ON_EACH_SIDE + ON_ENDS):
                    page_range.extend(range(0, ON_EACH_SIDE - 1))
                    page_range.append(DOT)
                    page_range.extend(
                        range(page_num - ON_EACH_SIDE, page_num + 1))
                else:
                    page_range.extend(range(0, page_num + 1))
                if page_num < (paginator.num_pages - ON_EACH_SIDE - ON_ENDS - 1):
                    page_range.extend(
                        range(page_num + 1, page_num + ON_EACH_SIDE + 1))
                    page_range.append(DOT)
                    page_range.extend(range(
                        paginator.num_pages - ON_ENDS, paginator.num_pages))
                else:
                    page_range.extend(range(page_num + 1, paginator.num_pages))

        need_show_all_link = self.can_show_all and not self.show_all and self.multi_page
        return {
            'cl': self,
            'pagination_required': pagination_required,
            'show_all_url': need_show_all_link and self.get_query_string({ALL_VAR: ''}),
            'page_range': map(self.get_page_number, page_range),
            'ALL_VAR': ALL_VAR,
            '1': 1,
        } 