(function() {
  var forms = document.getElementsByClassName('edit_submission_score');

  function handleSuccessfulSave(evt, data, status, xhr) {
    createFlashNotification("success", "Saved!");
  }

  for (var i = 0; i < forms.length; i++) {
    $(forms[i]).on('ajax:success', handleSuccessfulSave);
  }
})();
