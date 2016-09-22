(function() {
  $(document).ready(enableSearchOptions);

  function enableSearchOptions() {
    $('button[data-update-location]').on('click', function(e) {
      e.preventDefault();

      var $target = $(e.target),
          $locationField = $('input[data-location-field="true"]'),
          updateValue = $target.data('update-location');

      $locationField.val(updateValue);
      $target.closest('form').submit();
    });
  }
})();
