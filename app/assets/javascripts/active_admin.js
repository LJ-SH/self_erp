//= require active_admin/base
//= require i18n/jquery.ui.datepicker-custom

// start-of-jQuery-code-for-model supplier ====================================
function remove_fields(link) {
  $(link).closest("legend").next("input[type=hidden]").val("1");
  $(link).closest("fieldset").hide();
  reorder_child_title($('#fields-for-user'));
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  var index = $('#fields-for-user').find('fieldset:visible').size()+1;
  var regexp2 = new RegExp("new_index", "g");
  $('#fields-for-user').append(content.replace(regexp, new_id).replace(regexp2,index));
}

$(document).on('click', '.dumb_link_for_hide_and_show_only', function(){
  $(this).closest('fieldset.inputs').find("ol").toggle();
})

$(document).on('click', '.dumb_sub_link_for_hide_and_show_only', function(){
  $(this).closest("fieldset").find("ol>li").toggle();
})

function reorder_child_title(link) {
  var start_index = $(link).find('fieldset.child_list:visible').size()+1;
  $(link).find("fieldset.new_child_list:visible").each(function(index) {
  	$(this).find("a.dumb_sub_link_for_hide_and_show_only").html("#"+(start_index+index)+" User");
  });
}

// end-of-jQuery-code-for-model supplier ======================================

// start-of-jQuery-code-for-component_category_edit&new_form ===================
/*$(document).on('change', '#component_category_ancestry_depth', function() { 
  $.ajax({
    url: "/admin/component_categories/category_select",
    type: "get",
    data: {"category_type" : $(this).val()},
    //dataType: "script",
    dataType: "html",
    success: function(data){
      $("#active_admin_content").empty();
      $("#active_admin_content").append(data);
    }
  })
});

//$("#new_component_category").live('submit', function() {
$(document).on('submit', '#new_component_category', function() {  
    var form = $(this);
    var depth = form.find("#component_category_ancestry_depth").val();
    var ancestry_input = form.find("#component_category_ancestry");
    var ancestry_value;
    var errMsg = "请选择正确的值";

    if (depth == 0) {
      //ancestor is nil 
      ancestry_input.parent('li').remove();
      return true;
    }

    if (depth == 1) {
      var level0_element = $("#component_category_level0");
      if (!fn_integer_id_validate(level0_element.val())) {  
        if($("#new_category_level0_err_tip").length == 0) {
          var errTip = $('<p class="inline-errors" id="new_category_level0_err_tip"></p>').html(errMsg);
          level0_element.after(errTip);          
        }
        //event.preventDefault();
        return false;
      } else {
        $("#new_category_level0_err_tip").remove(); 
      }

      ancestry_input.val(level0_element.val());
      return true;
    }

    if (depth == 2) {
      var level0_element = $("#component_category_level0");
      var level1_element = $("#component_category_level1");
      if (!fn_integer_id_validate(level0_element.val())) {
        if($("#new_category_level0_err_tip").length == 0) {
          var errTip = $('<p class="inline-errors" id="new_category_level0_err_tip"></p>').html(errMsg);
          level0_element.after(errTip);          
        } 
        return false;
      } else {
        $("#new_category_level0_err_tip").remove();        
      }

      if (!fn_integer_id_validate(level1_element.val())) {
        if($("#new_category_level1_err_tip").length == 0) {
          var errTip = $('<p class="inline-errors" id="new_category_level1_err_tip"></p>').html(errMsg);
          level1_element.after(errTip);          
        } 
        return false;
      } else {
        $("#new_category_level1_err_tip").remove();        
      }  
      //value have been verified already
      ancestry_input.val(level0_element.val()+"/"+level1_element.val());
      return true;
    }

    if (depth == 3) {
      var level0_element = $("#component_category_level0");
      var level1_element = $("#component_category_level1");
      var level2_element = $("#component_category_level2");
      if (!fn_integer_id_validate(level0_element.val())) {
        if($("#new_category_level0_err_tip").length == 0) {
          var errTip = $('<p class="inline-errors" id="new_category_level0_err_tip"></p>').html(errMsg);
          level0_element.after(errTip);          
        } 
        return false;
      }else {
        $("#new_category_level0_err_tip").remove();        
      }

      if (!fn_integer_id_validate(level1_element.val())) {
        if($("#new_category_level1_err_tip").length == 0) {
          var errTip = $('<p class="inline-errors" id="new_category_level1_err_tip"></p>').html(errMsg);
          level1_element.after(errTip);          
        } 
        return false;
      } else {
        $("#new_category_level1_err_tip").remove();        
      }

      if (!fn_integer_id_validate(level2_element.val())) {
        if($("#new_category_level2_err_tip").length == 0) {
          var errTip = $('<p class="inline-errors" id="new_category_level2_err_tip"></p>').html(errMsg);
          level2_element.after(errTip);          
        } 
        return false;
      } else {
        $("#new_category_level2_err_tip").remove();        
      }

      //value have been verified already
      ancestry_input.val(level0_element.val()+"/"+level1_element.val()+"/"+level2_element.val());
      return true;
    }
});*/

$(document).on('change', 'select.new_form_component_category_ancestry_depth', function() { 
  var sel_idx = $(this).val();
  if (sel_idx == "") return;
  $('select.cc_selection').slice(sel_idx).parent('li').hide();
  $('select.cc_selection:lt('+ sel_idx + ')').parent('li').show();
});

$(document).ready(function() {
  if ($('select.new_form_component_category_ancestry_depth').length>0) {
    var sel_idx = $('select.new_form_component_category_ancestry_depth').val();
    $('select.cc_selection').slice(sel_idx).parent('li').hide();
  }
});

$(document).on('submit', '#new_component_category', function() {  
  var form = $(this);
  var depth_input = form.find("select.new_form_component_category_ancestry_depth");
  var depth_value = depth_input.val();
  var parent_input = form.find("#component_category_parent_id");
  var errMsg = "请选择正确的值";

  if (!fn_integer_id_validate(depth_value)) {
    if($("#new_category_ancestry_depth_err_tip").length == 0) {    
      var errTip = $('<p class="inline-errors" id="new_category_ancestry_depth_err_tip"></p>').html(errMsg);
      depth_input.after(errTip);   
    }
    return false; 
  } else {
    $("#new_category_ancestry_depth_err_tip").remove();
  }

  if (depth_value == 0) {
    parent_input.val('');
  } else {
    var parent_idx = depth_value-1;
    if (fn_chk_ancestor(form, depth_value)) {
      parent_input.val($('select.cc_selection:eq('+parent_idx+')').val());
    } else {
      return false;
    }
  }  

  $('select.cc_selection').attr("disabled", true);
  return true;    
});

function fn_integer_id_validate(value) {
  //digital with 3-5 bits
  var regExp = new RegExp(/^\d{1,3}$/);  
  return regExp.test(value);
}

function fn_chk_ancestor(f,depth_value) {
  var errMsg = "请选择正确的值";
  var b_rtn = true;
  f.find('select.cc_selection:lt('+depth_value+')').each(function(index) {
    if (!fn_integer_id_validate($(this).val())) {
      if(f.find("#new_category_category_err_tip_level_"+index).length == 0) {  
        var errTip = $('<p class="inline-errors" id="new_category_category_err_tip_level_'+index+'"></p>').html(errMsg);
        $(this).after(errTip);
      }
      b_rtn = false;
    } else {
      $("#new_category_category_err_tip_level_"+index).remove();
    }
  });  
  return b_rtn; 
}

// end-of-jQuery-code-for-component_category_edit&new_form ===================

// start-of-jQuery-code-for-component_category_search_panel ===================
$(document).ready(function() {
  $("form.component_category_filter_form").submit(component_category_end_node_selection);
});
// end-of-jQuery-code-for-component_category_search_panel ===================

// start-of-jQuery-code-for-part_number_selection_edit&new_form ===================
$(document).on('change', 'select.cc_leaf_node', function() {
  $.ajax({
    url: "/component_category_select/cc_code",
    context: this,
    type: "GET",
    data: "node=" + $(this).val(),
    dataType: "text",
    success: function(data){
      $("#part_number_cc_code").val(data);
    }
  })
});

//$(document).on('submit', '#new_part_number', part_number_form_pre_check);  
$(document).on('submit', 'form.part_number', function() {  
  var form = $(this);
  var supplier_val = form.find("#part_number_supplier_id").val();
  var reserved_code_val = form.find("#part_number_reserved_code").val();
  var cc_code_val = form.find("#part_number_cc_code").val();
  var supplier = form.find("#part_number_supplier_id");
  var reserved_code = form.find("#part_number_reserved_code");
  //var cc_code = form.find("#part_number_cc_code");  
  var errMsg = "请选择正确的值";

  if (!fn_chk_ancestor(form, 4)) {
    return false;
  }

  var regExp_8digits = new RegExp(/^\d{8}$/);
  if (!regExp_8digits.test(cc_code_val)) {
    if($("#code_err_tip").length == 0) {
      var errTip = $('<p class="inline-errors" id="code_err_tip"></p>').html(errMsg);
      form.find("#part_number_component_category_id").after(errTip);
    }
    return false;
  } else {
    $("#code_err_tip").remove();
  }

  var regExp_4digits = new RegExp(/^\d{4}$/);
  if (!regExp_4digits.test(reserved_code_val)) {
    if($("#reserved_code_err_tip").length == 0) {
      var errTip = $('<p class="inline-errors" id="reserved_code_err_tip"></p>').html(errMsg);
      reserved_code.after(errTip);
    }
    return false;
  } else {
    $("#reserved_code_err_tip").remove();
  } 
  
  if(supplier_val=="") {
    if($("#supplier_err_tip").length == 0) {
      var errTip = $('<p class="inline-errors" id="supplier_err_tip"></p>').html(errMsg);
      supplier.after(errTip);
    }
    return false;
  } else {
    $("#supplier_err_tip").remove();
  } 
  supplier_str = "";
  supplier_len = 3;
  supplier_str = Array(supplier_len>supplier_val.length? (supplier_len-supplier_val.length+1):0).join(0)+supplier_val
  
  form.find("#part_number_code").val(cc_code_val+"-"+reserved_code_val+"-"+supplier_str);
  form.find("select.cc_ancestor_node").remove();
});

// end-of-jQuery-code-for-part_number_edit&new_form ===================

// start-of-jQuery-code-for-part_number_search_form ===================
$(document).on('submit', 'form.part_number_filter_form', component_category_end_node_selection);  
// end-of-jQuery-code-for-part_number_search_form ===================

// start-of-jQuery-code-for-common_component_category_ajax_methods ============
$(document).on('change', 'select.cc_selection', function() {
  $.ajax({
    url: "/component_category_select/children_collection",
    context: this,
    type: "GET",
    data: "node=" + $(this).val(),
    dataType: "json",
    success: function(data){
      var next_level_index = $('select.cc_selection').index($(this))+1;
      var level = $('select.cc_selection:eq('+ next_level_index + ')');
      level.empty();
      level.append("<option value=''>请选择分类类型</option>");       
      $.each(data, function(index, value) {
        // append an option
        var opt = $('<option/>');
        // value is an array: [:id, :name]
        opt.attr('value', value[0]);
        // set text
        opt.text(value[1]);
        // append to select
        opt.appendTo(level);
      });    
      $('select.cc_selection:gt('+next_level_index+')').each(function() {
        var blank_level = $(this);
        blank_level.empty();
        //blank_level.append("<option value=''></option>");
        blank_level.append("<option value=''>请选择分类类型</option>");        
      });   
    }
  })
});

$(document).on('change', 'select.search_cc_selection', function() {   
  $.ajax({
    url: "/component_category_select/children_collection",
    context: this,
    type: "GET",
    data: "node=" + $(this).val(),
    dataType: "json",
    success: function(data){
      var next_level_index = $('select.search_cc_selection').index($(this))+1;
      var level = $('select.search_cc_selection:eq('+ next_level_index + ')');
      level.empty();
      level.append("<option value=''>任何</option>");       
      $.each(data, function(index, value) {
        // append an option
        var opt = $('<option/>');
        // value is an array: [:id, :name]
        opt.attr('value', value[0]);
        // set text
        opt.text(value[1]);
        // append to select
        opt.appendTo(level);
      });    
      $('select.search_cc_selection:gt('+next_level_index+')').each(function() {
        var blank_level = $(this);
        blank_level.empty();
        blank_level.append("<option value=''>任何</option>");       
      });         
    }
  })
});

function component_category_end_node_selection() {
  var level_idx = "";
  $('select.search_cc_selection').each(function(index) {
    if ($(this).val() != "") {
      level_idx = index;
    }       
  });
  $('select.search_cc_selection:lt('+level_idx+')').each(function() {
    $(this).attr("disabled", true);
  }); 
}

/* end-of-jQuery-code-for-common_component_category_ajax_methods ==============
$(document).ready(function(){
  $('form.bom_part_number_filter_form').bind('ajax:success', function(evt,data,status,xhr) {
    var level = $('select.part_number_collection_in_bom_part');
    level.empty();
    //level.append("<option value=''>任何</option>");     
    $.each(data, function(index, value) {
        // append an option
        var opt = $('<option/>');
        // value is an array: [:id, :name]
        opt.attr('value', value[0]);
        // set text
        opt.text(value[1]);
        // append to select
        opt.appendTo(level);      
    })
  }).bind('ajax:beforeSend', function(evt,xhr,settings){
    alert(settings.url);
  });  
});*/

$(document).on('change', 'input.bom_part_part_number_sel[type=radio]', function() {
  $("#bom_part_part_number_id").val($(this).val());
});

/* start-of-bom-part-number-new form */
$(document).on('submit', '#new_bom_part', function() {  
  if ($("input.bom_part_part_number_sel[type=radio]:checked").length == 0) {
    alert("必须选择一个元器件");
    return false;
  }
  return true;
});
 