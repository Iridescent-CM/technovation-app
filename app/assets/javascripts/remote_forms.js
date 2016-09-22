(function() {
  $(document).ready(enableRemoteCheckboxes);

  function enableRemoteCheckboxes() {
    $('form[data-remote="true"]').find('input[type="checkbox"]').on('change', function(e) {
      var ajaxMsgElem = $('<div />').attr('class', 'currentAjaxMsg');
      $('body').prepend(ajaxMsgElem);
      $(e.target).closest('form').submit();
    });

    $(document).on('ajax:success', function() {
      $('.currentAjaxMsg').addClass('alert alert-info')
                          .text('Saved!')
                          .fadeIn('easein')
                          .delay(500)
                          .fadeOut('easein', function() { $(this).remove(); });
    });
  }
})();
