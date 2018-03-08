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
//= require rails-ujs-overrides
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
