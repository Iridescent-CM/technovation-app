(function() {
  autoSubmitButtonlessForms();

  function autoSubmitButtonlessForms() {
    var inputs = document.querySelectorAll('form[data-remote] input');

    forEach(inputs, function(input) {
      input.addEventListener('change', function(e) {
        var form = closest(e.target, 'form');
        form.submit();
      });
    });
  }
})();
