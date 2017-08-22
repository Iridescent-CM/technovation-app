document.addEventListener("turbolinks:load", function(e) {
  $(".toggle-based-search").on("change", function() {
    $(this).closest("form").submit();
  });
});
