document.addEventListener("turbolinks:load", function() {
  $('[data-toggle]')
    .each(toggleAttachedField)
    .on('change', toggleAttachedField);

  function toggleAttachedField() {
    const toggleOnValue = $(this).data('toggle-value'),
          toggleFieldSelector = $(this).data('toggle-reveal'),
          $field = $(toggleFieldSelector);

    if ($(this).val() === toggleOnValue) {
      $field.fadeIn();
    } else {
      $field.fadeOut();
    }
  }
});
