//= require vanilla-ujs

//= require url-search-params-polyfill
//= require admin/utils

//= require account_geolocation
//= require location_confirm

//= require toast_flashes
//= require fancy_uploads
//= require modalify
//= require background_checks

//= require datetime
//= require admin-results-tables
//= require admin-filter-options

(function resizeTextAreas() {
  resizeTextAreaheightByContent();

  function resizeTextAreaheightByContent() {
    var textareas = document.querySelectorAll('textarea');

    textareas.forEach(function(ta) {
      console.log("resizing textarea", ta.id);
      ta.style.height = ta.scrollHeight / 1.25 + "px";
    });
  }
})();
