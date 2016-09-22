(function() {
  $(document).ready(enableRemoteCheckboxes);

  function enableRemoteCheckboxes() {
    $('form[data-remote="true"]').find('input[type="checkbox"]').on('change', function(e) {
      var ajaxMsgElem = $('<span />').attr('id', 'currentAjaxMsg');
      $(e.target).closest('form').append(ajaxMsgElem);
      $(e.target).closest('form').submit();
    });

    $(document).on('ajax:success', function() {
      $('#currentAjaxMsg').addClass('alert alert-success')
                          .text('Your setting was updated.')
                          .fadeIn('easein')
                          .delay(3000)
                          .fadeOut('easein', function() { $(this).remove(); });
    });
  }
})();
