(function() {
  $(document).ready(enableRemoteCheckboxes);
  $(document).ready(enableWordCount);

  function enableRemoteCheckboxes() {
    $('form[data-remote="true"]').find('input[type="checkbox"]').on('change', function(e) {
      $(e.target).closest('form').submit();
    });

    $(document).on('ajax:success', function() {
      var successFlash = document.createElement('div');
      successFlash.classList.add('flash', 'flash--success');
      successFlash.innerHTML = 'Saved!';
      successFlash.dataset.timeout = 750;
      document.body.appendChild(successFlash);
    });
  }

  function enableWordCount() {
    $(document).on('keyup', '[data-count-words="true"]', function(e) {
      var words = e.target.value.match(/\S+/g),
          wordCount = words ? words.length : 0;

      $('[data-word-count-show="true"]').text('Words: ' + wordCount);
    });
  }
})();
