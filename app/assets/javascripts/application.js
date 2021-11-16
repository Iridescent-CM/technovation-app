// ******** POLYFILLS
//= require ie11-polyfills

// ******** VENDOR
//
//= require turbolinks
//= require jquery3
//= require jquery_ujs
//= require chosen-jquery
//= require promise-polyfill.min
//= require sweetalert2
//= require jquery.sticky-kit.min
//= require ready

// ******** APP
//
//= require rails-ujs-overrides
//= require navigation
//= require chosen-init
//= require flash-msgs
//= require tabs
//= require student-dropdown
//= require student-tabs
//= require image-uploaders
//= require location-details
//= require modals
//= require sticky-cols

$(document).ajaxSend(function(evt, xhr, opts) {
  if (!opts.crossDomain)
    xhr.setRequestHeader(
      'X-CSRF-Token',
      $('meta[name="csrf-token"]').attr('content')
    );
});

$.ajaxPrefilter(function (options) {
  if (options.crossDomain && jQuery.support.cors) {
    var http = (window.location.protocol === 'http:' ? 'http:' : 'https:');
    options.url = http + '//cors-anywhere.herokuapp.com/' + options.url;
    //options.url = "http://cors.corsproxy.io/url=" + options.url;
  }
});