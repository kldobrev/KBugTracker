$(document).ready(function() { 
    
  $("#main_nav > li").mouseover(function() {
    $(".main_nav_inner", this).css({"visibility": "visible"});
  });
	
  $("#main_nav > li").mouseout(function() {
    $(".main_nav_inner", this).css({"visibility": "hidden"});
  });
	
  $(".visibility_button").click(function() {
    $(".invisible_component").css({"display": "block"});
  });
	
  $("#search_pr_radio").click(function() {
    $("#search_pr_form").css({"display": "block"});
    $("#search_usr_form").css({"display": "none"});
  });
	
  $("#search_usr_radio").click(function() {
    $("#search_pr_form").css({"display": "none"});
    $("#search_usr_form").css({"display": "block"});
  });
	
  $("#add_tag_button").click(function() {
    $(".tag_field").first().clone().appendTo(".tags_form");
  });
	
  $("#invite_pr_button").click(function() {
    $("#give_ownership_form").css({"display": "none"});
    $("#invite_proj_form").load("/editable_projects/" + $("#invite_pr_button").data("usr")).css({"display": "block"});
  });

  $("#give_ownership_button").click(function() {
    $("#invite_proj_form").css({"display": "none"});
    $("#give_ownership_form").load("/owned_projects/" + $("#give_ownership_button").data("usr")).css({"display": "block"});
  });

  $("#add_gr_member_button").click(function() {
    $("#add_gr_member_form").load("/all_proj_members/" + $("#add_gr_member_button").data("gr")).css({"display": "block"});
  });

  $("#asgn_type_usr").click(function() {
    $("#defect_assigned_to_id").css({"display": "block"});
    $("#defect_to_group_id").css({"display": "none"});
    $("#defect_to_group_id").val("");
  });

  $("#asgn_type_gr").click(function() {
    $("#defect_assigned_to_id").css({"display": "none"});
    $("#defect_assigned_to_id").val("");
    $("#defect_to_group_id").css({"display": "block"});
  });

  $("#all_comments").load("/projects/" + $("#def_comment_section").data("pr") + "/defects/" + $("#def_comment_section").data("df") + "/comments");
  $("#new_comment").load("/projects/" + $("#def_comment_section").data("pr") + "/defects/" + $("#def_comment_section").data("df") + "/comments/new" );

});

$(document).ajaxComplete(function() {

  $("#edit_comment_button").click(function() {
    $("#new_comment").load("/comments/" + $("#edit_comment_button").data("cmnt") + "/edit");
  });

}); 

