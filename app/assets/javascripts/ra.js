//= require jquery2
//= require chosen-jquery
// PLEASE DO NOT USE JQUERY, LEGACY SUPPORT ONLY

//= require lodash
//= require url-search-params-polyfill
//= require event-polyfill
//= require jquery_ujs

//= require admin/utils

//= require account_geolocation
//= require location_confirm

//= require toast_flashes
//= require fancy_uploads
//= require modalify
//= require tabs
//= require background_checks

//= require datetime
//= require admin-results-tables
//= require admin-filter-options

(function resizeTextAreas() {
  resizeTextAreaheightByContent();

  function resizeTextAreaheightByContent() {
    var textareas = document.querySelectorAll('textarea');

    textareas.forEach(function(ta) {
      ta.style.height = ta.scrollHeight / 1.25 + "px";
    });
  }
})();

(function enableChosen() {
  $('.chosen').chosen({
    width: '250px',
  });
})();

(function showHideAction() {
  $('.show-hide-action span').on('click', function(e) {
    var $target = $(e.target);

    $target.next('.show-hide-panel').toggle();

    if ($target.text() === "Show") {
      $target.text("Hide");
    } else {
      $target.text("Show");
    }
  });
})();
