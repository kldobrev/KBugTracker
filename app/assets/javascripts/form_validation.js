  // Common
  function add_error_msg(msg) {
    $("#flashes_off").css({"display": "block"}).attr("id", "flashes_on").attr("class", "fl_err");
    $("<li>" + msg + "</li>").appendTo("#flashes_on");
  }

  function reset_error_list() {
    $("#flashes_on").children().remove();
    $("#flashes_on").attr("id", "flashes_off");
  }

  function included_in_arr(value, array) {
    for(var i = 0; i < array.length; i++) {
      if(array[i] == value) {
        return true;
      }
    }
    return false;
  }

  // Comments
  function validate_comment() {
    reset_error_list();
    var comment = $("#comment_content").val();
    if(comment == "") {
      add_error_msg("Comment content can't be blank.");
      return false;
    }
    return true;
  }
  
  // Users
  function validate_user() {
    reset_error_list();
    var email = $("#user_email").val();

    if(email == "") {
      add_error_msg("Email can't be blank.");
      return false;
    } else if(!email.match(/[a-zA-Z0-9]{2,}[\w]*\@\w{2,}\.[a-z]{2,}/)) {
      add_error_msg("Not a valid email adress.");
      return false;
    }
    return true;
  }

  // Projects
  function validate_project() {
    reset_error_list();
    var title = $("#project_title").val();

    if(title.length < 3) {
      add_error_msg("Project title must be at least 3 characters long.");
      return false;
    }
    return true;
  }

  // Defects
  function validate_defect() {
    reset_error_list();
    var invalid_flg = false;
    var title_elem = $("#defect_title");
    var assigned_to = $("#defect_assigned_to_id").val();
    var to_group = $("#defect_to_group_id").val();
    var stat = $("#defect_status").val();
    var importance = $("#defect_importance").val();

    if(title_elem.length != 0 && title_elem.val().length < 3) {
      add_error_msg("Defect title should be at least 3 characters long.");
      invalid_flg = true;
    }
    if(assigned_to == "" && to_group == "") {
      add_error_msg("The defect must be assigned to a group or a user.");
      invalid_flg = true;
    }
    if(!included_in_arr(stat, ["0", "1", "2", "3"])) {
      add_error_msg("Current status value is not supported.");
      invalid_flg = true;
    }
    if(!included_in_arr(importance, ["0", "1", "2", "3"])) {
      add_error_msg("Current importance value is not supported.");
      invalid_flg = true;
    }

    return !invalid_flg;
  }
