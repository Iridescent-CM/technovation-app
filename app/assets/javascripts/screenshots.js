$(document).on("ajax:success", "[data-remove-on-delete]", function(e) {
  $(this).closest(".remove-on-delete").fadeOut(function() {
    $(this).remove();
  });
});
