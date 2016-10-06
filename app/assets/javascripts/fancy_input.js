(function() {
  $(document).ready(initFancyInput);

  function initFancyInput() {
    $(document).on('keyup', 'input[type="text"]', function(e) {
      if (e.keyCode === 13) {
        location.href = location.pathname + $.query.set($(e.target).data('param'), e.target.value).toString();
      }
    });
  }
})();
