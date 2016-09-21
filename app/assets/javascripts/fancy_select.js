/*
 * Select fields that reload the page with their selected value
 */

(function() {
  $(document).on('DOMContentLoaded', initFancySelect);

  function initFancySelect() {
    $(document).on('change', 'select[data-reload="true"]', function(e) {
      location.href = location.pathname + $.query.set($(e.target).data('param'), e.target.value).toString();
    });
  }
})();
