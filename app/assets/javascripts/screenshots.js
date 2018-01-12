$(document).on("ajax:success", "[data-remove-on-delete]", function(e) {
  var $link = $(this),
      $li = $link.closest(".remove-on-delete"),
      $dzPreview = $(".remove-with-" + $li.prop("id"));

  $li.fadeOut(function() {
    $li.remove();

    requestAnimationFrame(function() {
      $("#sortable-list").trigger("removedfile");
    });

    $dzPreview.fadeOut(function() {
      $dzPreview.remove();
      $(".dz-started").removeClass("dz-started");
    });
  });
});
