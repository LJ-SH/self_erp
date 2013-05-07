//= require active_admin/base

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
$(document).on('change', '#component_category_ancestry_depth', function() { 
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

$(document).on('change', '#component_category_level0', function() {   
  $.ajax({
    url: "/admin/component_categories/level1_collection",
    type: "GET",
    data: "level0=" + $(this).val(),
    dataType: "json",
    success: function(data){
      var level1 = $("#component_category_level1");
      level1.empty();
      level1.append("<option value=''></option>");       
      $.each(data, function(index, value) {
        // append an option
        var opt = $('<option/>');
        // value is an array: [:id, :name]
        opt.attr('value', value[0]);
        // set text
        opt.text(value[1]);
        // append to select
        opt.appendTo(level1);
      });    
      var level2 = $("#component_category_level2");
      level2.empty();
      level2.append("<option value=''></option>");
      level2.append("<option value=''>请选择分类类型</option>");        
    }
  })
}); 

$(document).on('change', '#component_category_level1', function() {     
  $.ajax({
    url: "/admin/component_categories/level2_collection",
    type: "GET",
    data: "level1=" + $(this).val(),
    dataType: "json",
    success: function(data){
      var level2 = $("#component_category_level2");
      level2.empty();
      level2.append("<option value=''></option>");       
      $.each(data, function(index, value) {
        // append an option
        var opt = $('<option/>');
        // value is an array: [:id, :name]
        opt.attr('value', value[0]);
        // set text
        opt.text(value[1]);
        // append to category_select
        opt.appendTo(level2);
      });      
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
});

function fn_integer_id_validate(value) {
  //digital with 3-5 bits
  var regExp = new RegExp(/^\d{1,3}$/);  
  return regExp.test(value);
}
// end-of-jQuery-code-for-component_category_edit&new_form ===================

// start-of-jQuery-code-for-component_category_search_panel ===================
$(document).on('change', '#q_level0_eq', function() { 
  $.ajax({
    url: "/admin/component_categories/level1_collection",
    type: "GET",
    data: "level0=" + $(this).val(),
    dataType: "json",
    success: function(data){
      var level1 = $("#q_level1_eq");
      level1.empty();
      level1.append("<option value=''>任何</option>");
      $.each(data, function(index, value) {
        // append an option
        var opt = $('<option/>');
        // value is an array: [:id, :name]
        opt.attr('value', value[0]);
        // set text
        opt.text(value[1]);
        // append to select
        opt.appendTo(level1);
      });      
      //reset level2 settings
      var level2 = $("#q_level2_eq");
      level2.empty();
      level2.append("<option value=''>任何</option>");
    }
  })
});

$(document).on('change', '#q_level1_eq', function() {  
  $.ajax({
    url: "/admin/component_categories/level2_collection",
    type: "GET",
    data: "level1=" + $(this).val(),
    dataType: "json",
    success: function(data){
      var level2 = $("#q_level2_eq");
      level2.empty();
      level2.append("<option value=''>任何</option>");
      $.each(data, function(index, value) {
        // append an option
        var opt = $('<option/>');
        // value is an array: [:id, :name]
        opt.attr('value', value[0]);
        // set text
        opt.text(value[1]);
        // append to select
        opt.appendTo(level2);
      });      
    }
  })
});

$(document).ready(function() {
  $("#q_search").submit(function() {
    if ($("#q_level2_eq").val() != "") {
      $("#q_level0_eq").attr("disabled", true);
      $("#q_level1_eq").attr("disabled", true);     
    } else {
      if ($("#q_level1_eq").val() != "") {
        $("#q_level0_eq").attr("disabled", true); 
      } 
    }
  });
});
// end-of-jQuery-code-for-component_category_search_panel ===================