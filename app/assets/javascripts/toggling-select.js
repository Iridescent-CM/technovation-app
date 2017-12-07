var toggleAttachedField;

toggleAttachedField = function () {
  var $selectField = $(this);

  $.each($(this).data("toggles"), function(selectValue, revealSelector) {
    var $field = $(revealSelector);

    if ($selectField.val() === selectValue) {
      $field.fadeIn();
    } else {
      $field.fadeOut();
    }
  });
}

$(document).on("change", "[data-toggles]", toggleAttachedField);

$(document).on("ready turbolinks:load", function() {
  $('[data-toggles]').each(toggleAttachedField);
});
