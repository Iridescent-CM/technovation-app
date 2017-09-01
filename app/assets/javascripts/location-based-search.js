document.addEventListener("turbolinks:load", function(e) {
  $(".location-based-search [data-update-location]").on("click", function(e) {
    e.preventDefault();

    var $field = $(this).closest(".location-based-search")
                        .find("[data-location-field]");

    $field.val($(this).data("update-location"));

    $field.closest("form").submit();
  });
});
