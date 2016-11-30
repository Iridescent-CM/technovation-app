(function submissionsPage() {
  if (!document.querySelector('[data-team-submissions]')) {
    return;
  }

  var wrapper = document.getElementById("ts-app-description-wrapper");
  var buttonsWrapper = document.getElementById("ts-app-description-buttons-wrapper");
  var primaryEditableButton = document.getElementById("ts-primary-editable-btn");
  var cancelEditableButton = document.getElementById("ts-cancel-editable-btn");
  var editableContent = wrapper.querySelectorAll('[data-editable]');

  var editableWrapperClass = 'ts-app-description--editable';
  var visibleCancelButtonClass = 'ts-app-description__cancel-btn--show';

  var isEditable = false;
  //var contentObj = Array.prototype.reduce

  primaryEditableButton.addEventListener('click', makeContentEditable);

  function makeContentEditable() {
    primaryEditableButton.removeEventListener('click', makeContentEditable);
    wrapper.classList.add(editableWrapperClass);
    cancelEditableButton.classList.add(visibleCancelButtonClass);
    cancelEditableButton.addEventListener('click', cancelEditable);
  }

  function cancelEditable() {

  }
})();
