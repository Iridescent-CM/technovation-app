//Override the default confirm dialog by rails
$.rails.allowAction = function(link) {
  if (link.data("confirm") == undefined)
    return true;

  $.rails.showConfirmationDialog(link);
  return false;
}

//User click confirm button
$.rails.confirmed = function(link) {
  link.data("confirm", null);
  link.trigger("click.rails");
}

//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link) {
  var positive = link.data("positive");

  swal({
    html: link.data("confirm"),
    cancelButtonText: "No, go back",
    confirmButtonText: "Yes, do it",
    confirmButtonColor: positive ? "#5ABF94" : "#D8000C",
    showCancelButton: true,
    reverseButtons: true,
    focusCancel: true,
  }).then(result => {
    if (result.value) {
      $.rails.confirmed(link);
    }
  });
}
