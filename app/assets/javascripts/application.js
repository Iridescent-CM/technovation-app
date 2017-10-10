// ******** VENDOR
//
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require chosen-jquery
//= require sweetalert2

// ******** APP
//
//= require navigation
//= require chosen-init
//= require flash-msgs
//= require tabs
//= require image-uploaders
//= require location-details

$(document).ajaxSend(function(_, xhr) {
  xhr.setRequestHeader(
    'X-CSRF-Token',
    $('meta[name="csrf-token"]').attr('content')
  );
});

//Override the default confirm dialog by rails
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}

//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}

//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var positive = link.data("positive");

  swal({
    text: link.data("confirm"),
    cancelButtonText: "No, go back",
    confirmButtonText: "Yes, do it",
    confirmButtonColor: positive ? "#5ABF94" : "#D8000C",
    showCancelButton: true,
    reverseButtons: true,
    focusCancel: true,
  }).then(
    function() { $.rails.confirmed(link); },
    function() { return; }
  );
}

document.addEventListener("turbolinks:load", function() {
  $("[data-opens-modal]").on("click", function(e) {
    e.preventDefault();

    var modal = $('#' + $(this).data("opensModal"));

    swal({
      html: modal.find(".modal-content"),
      title: modal.data("heading") || "",
      showCloseButton: true,
      showConfirmButton: false,
      onOpen: makeFileFieldUnique,
    })

    function makeFileFieldUnique(modal) {
      var $form = $(modal).find("form"),
          $label = $form.find("label"),
          $field = $form.find("input[type=file]"),
          newId = Math.random()
            .toString(36)
            .replace(/[^a-z]+/g, '')
            .substr(0, 7);

      $field.prop("id", newId);
      $label.prop("for", newId);
    }
  });
});
