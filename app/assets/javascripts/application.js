// ******** VENDOR
//
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require chosen-jquery
//= require sweetalert2
//= require jquery.sticky-kit.min

// ******** APP
//
//= require navigation
//= require chosen-init
//= require flash-msgs
//= require tabs
//= require image-uploaders
//= require location-details
//= require modals
//= require sticky-cols

$(document).ajaxSend(function(_, xhr) {
  xhr.setRequestHeader(
    'X-CSRF-Token',
    $('meta[name="csrf-token"]').attr('content')
  );
});

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
    text: link.data("confirm"),
    cancelButtonText: "No, go back",
    confirmButtonText: "Yes, do it",
    confirmButtonColor: positive ? "#5ABF94" : "#D8000C",
    showCancelButton: true,
    reverseButtons: true,
    focusCancel: true,
  }).then((result) => {
    if (result.value) {
      $.rails.confirmed(link);
    }
  });
}

function confirmNegativeSwal (opts) {
  return swal({
    title: opts.title,
    text: opts.text,
    html: opts.html,
    cancelButtonText: "No, go back",
    confirmButtonText: opts.confirmButtonText,
    confirmButtonColor: "#D8000C",
    showCancelButton: true,
    reverseButtons: true,
    focusCancel: true,
  });
}
