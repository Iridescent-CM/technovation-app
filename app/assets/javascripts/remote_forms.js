(function() {
  $(document).ready(enableRemoteCheckboxes);

  function enableRemoteCheckboxes() {
    $('form.remote_checkboxes').find('input[type="checkbox"]').on('change', function(e) {
      $(e.target).closest('form').submit();
    });

    $('form.remote_checkboxes').on('ajax:success', function() {
      var successFlash = document.createElement('div');
      successFlash.classList.add('flash', 'flash--success');
      successFlash.innerHTML = 'Saved!';
      successFlash.dataset.timeout = 750;
      document.body.appendChild(successFlash);
    });
  }
})();
