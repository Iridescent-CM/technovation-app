// ******** VENDOR
//
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require chosen-jquery

// ******** APP
//
//= require navigation
//= require chosen-init
//= require flash-msgs
//= require modals
//= require tabs
//= require image-uploaders
//= require location-details

$(document).ajaxSend(function(_, xhr) {
  xhr.setRequestHeader(
    'X-CSRF-Token',
    $('meta[name="csrf-token"]').attr('content')
  );
});
