document.addEventListener("turbolinks:load", function() {
  // Assumes a remote enabled form
  $("[data-submit-on-change]").on("change", "input", function() {
    $(this).submit();
  });
});
