//= require jquery2
// JQUERY IS INCLUDED HERE STRICTLY
// AS A DEPENDENCY OF TWITTER TYPEAHEAD

//= require jquery_ujs
// RAILS VIEW HELPER DEPENDENCY


//= reuqire toast_flashes
//= require fancy_uploads
//= require modalify

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
