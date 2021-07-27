$(document).on('click', '.flash .icon-close', function() {
  $(this).closest('.flash').fadeOut('easeout', function() {
    $('#flash').removeClass('fixed');
    $(this).remove();
  });
});

document.addEventListener('DOMContentLoaded', function() {
  $(document).ajaxComplete(function(_, xhr) {
    if (xhr.status === 200) {
      var res = false;

      try {
        res = JSON.parse(xhr.responseText);
      } catch (err) {
        return false;
      }

      if (!!res && !!res.flash) {
        displayFlashMessage(res.flash.success);
      }
    }
  });
});

function displayFlashMessage(message, classString) {
  if (!message) {
    return false;
  }

  var validClasses = ['success', 'error', 'alert'];
  var flashClass;

  if (validClasses.indexOf(classString) === -1) {
    flashClass = 'flash--success';
  } else {
    flashClass = 'flash--' + classString;
  }

  var $flash = $('<div>');
  var $flashText = $('<span>');
  var $flashClose = $('<span>');

  $flash.addClass('flash ' + flashClass);
  $flashClose.addClass('icon-close');
  $flashText.text(message);

  $flash.append($flashText);
  $flash.append($flashClose);

  $flash.hide();
  $('#flash').addClass('fixed').html($flash);
  $flash.fadeIn();

  return true;
}
