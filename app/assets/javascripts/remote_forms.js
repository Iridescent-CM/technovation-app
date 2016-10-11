(function() {
  $(document).ready(enableRemoteCheckboxes);
  $(document).ready(enableWordCount);

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

  function enableWordCount() {
    $(document).on('keyup', '[data-count-words="true"]', function(e) {
      var words = e.target.value.match(/\S+/g),
          wordCount = words ? words.length : 0;

      $('[data-word-count-show="true"]').text('Words: ' + wordCount);
    });
  }
})();
