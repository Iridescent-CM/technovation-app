$(document).on(
  "click",
  ".location-based-search [data-update-location]",
  function(e) {
    e.preventDefault();

    var $field = $(this).closest(".location-based-search")
                        .find("[data-location-field]");

    $field.val($(this).data("update-location"));

    $field.closest("form").submit();
  }
);

$(document).on("change", ".toggle-based-search", function(e) {
  $(this).closest("form").submit();
});

$(document).on("keyup", ".search-by-text", function(e) {
  if (e.keyCode === 13)
    $(this).closest('form').submit();
});
