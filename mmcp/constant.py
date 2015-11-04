# coding=utf-8

MAX_PROJECT_MATERIAL_QANTITY = 99999 


#用于 项目材料审批 
APPROVAL_FORM_HTML = """

<div class="panel panel-default formset fieldset  stacked" id="specification_set-group">
    <div class="panel-heading">   
      <h3 class="panel-title">审批</h3>
    </div>
                
    <form class="exform rended" enctype="multipart/form-data" method="post" id="item_form">
    <input type='hidden' name='csrfmiddlewaretoken' value={0} />
    <input type='hidden' name='document_id' value={1} />
    <input type="hidden" name="action" value="approval">

    <div class="form-container row clearfix">
    <div id="column-0" class="formColumn column form-column full col col-sm-12 form-horizontal ui-sortable" horizontal="True" span="12">
    <div class="panel panel-default fieldset unsort no_title" id="box-0">
    <div class="panel-heading"><i class="icon fa fa-chevron-up chevron"></i><h3 class="panel-title"></h3>
    </div>
    <div class="panel-body ">
    <div id="div_id_audit" class="form-group">
    <label for="id_audit" class="control-label  requiredField">审核<span class="asteriskField">*</span></label>
    <div class="controls ">
    <select class="form-control" id="id_audit" name="audit">
    <option value="1">审批通过</option>
    <option value="2">审批不通过</option>
    </select>
    </div>
    </div>
    <div id="div_id_comments" class="form-group">
    <label for="id_comments" class="control-label ">意见
    </label>
    <div class="controls ">
    <textarea class="textarea form-control" cols="40" id="id_comments" name="comments" rows="10"></textarea>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>


    <div class="form-actions well well-sm clearfix fixed">
    <div class="nav-collapse collapse more-btns">
    <input type="submit" class="btn btn-primary" value="确定" name="_continue">
    </div>
    </div>
    </form>            
                
                
                
</div>                               
"""

#用于 付款审批 因为付款单里面已有一个form，所以只要加字段显示审批的内容就可以了。
APPROVAL_NO_FORM_HTML = """

<div class="panel panel-default formset fieldset  stacked" id="specification_set-group">
    <div class="panel-heading">   
      <h3 class="panel-title">审批</h3>
    </div>
                
    <input type='hidden' name='csrfmiddlewaretoken' value={0} />
    <input type='hidden' name='document_id' value={1} />
    <input type="hidden" name="action" value="approval">

    <div class="form-container row clearfix">
    <div id="column-0" class="formColumn column form-column full col col-sm-12 form-horizontal ui-sortable" horizontal="True" span="12">
    <div class="panel panel-default fieldset unsort no_title" id="box-0">
    <div class="panel-heading"><i class="icon fa fa-chevron-up chevron"></i><h3 class="panel-title"></h3>
    </div>
    <div class="panel-body ">
    <div id="div_id_audit" class="form-group">
    <label for="id_audit" class="control-label  requiredField">审核<span class="asteriskField">*</span></label>
    <div class="controls ">
    <select class="form-control" id="id_audit" name="audit">
    <option value="1">审批通过</option>
    <option value="2">审批不通过</option>
    </select>
    </div>
    </div>
    <div id="div_id_comments" class="form-group">
    <label for="id_comments" class="control-label ">意见
    </label>
    <div class="controls ">
    <textarea class="textarea form-control" cols="40" id="id_comments" name="comments" rows="10"></textarea>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>


    <div class="form-actions well well-sm clearfix fixed">
    <div class="nav-collapse collapse more-btns">
    <input type="submit" class="btn btn-primary" value="确定" name="_continue">
    </div>
    </div>
                
                
                
</div>                               
"""