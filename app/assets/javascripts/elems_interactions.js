$(document).ready(function() {
	
	$("#main_nav > li").mouseover(function() {
		$(".main_nav_inner", this).css({"visibility": "visible"});
	});
	
	$("#main_nav > li").mouseout(function() {
		$(".main_nav_inner", this).css({"visibility": "hidden"});
	});
	
	$("#ch_pass_frm_button").click(function() {
		$("#ch_pass_req_frm").css({"visibility": "visible"});
	});
});