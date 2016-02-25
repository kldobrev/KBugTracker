$(document).ready(function() {
	
	$("#main_nav > li").mouseover(function() {
		$(".main_nav_inner", this).css({"visibility": "visible"});
	});
	
	$("#main_nav > li").mouseout(function() {
		$(".main_nav_inner", this).css({"visibility": "hidden"});
	});
	
	$(".visibility_button").click(function() {
		$(".invisible_component").css({"visibility": "visible"});
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
	
});