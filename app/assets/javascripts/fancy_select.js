/*
 * Select fields that reload the page with their selected value
 */

(function() {
  $(document).ready(initFancySelect);

  function initFancySelect() {
    $(document).on('change', 'select[data-reload="true"]', function(e) {
      location.href = location.pathname + $.query.set($(e.target).data('param'), e.target.value).toString();
    });

    $(document).on('change', 'form[data-fancy="true"] select', function(e) {
      $(e.target).closest('form').submit();
    });
  }
})();
