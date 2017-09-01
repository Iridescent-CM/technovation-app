$(document).on("click", ".location-based-search [data-update-location]", function(e) {
  e.preventDefault();

  var $field = $(this).closest(".location-based-search")
                      .find("[data-location-field]");

  $field.val($(this).data("update-location"));

  $field.closest("form").submit();
});
