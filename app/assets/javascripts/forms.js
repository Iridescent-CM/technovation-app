// Assumes a remote enabled form
$(document).on("change", "[data-submit-on-change] input", function() {
  $(this).submit();
});
