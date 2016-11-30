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

  var contentObj = Array.prototype.reduce.call(editableContent, function(obj, node) {
    obj[node.dataset.name] = node.innerText;
    return obj;
  }, {});

  var tempObject = {};

  primaryEditableButton.addEventListener('click', makeContentEditable);

  function makeContentEditable() {
    primaryEditableButton.removeEventListener('click', makeContentEditable);
    primaryEditableButton.innerText = 'Save Changes';

    wrapper.classList.add(editableWrapperClass);
    cancelEditableButton.classList.add(visibleCancelButtonClass);

    Array.prototype.forEach.call(editableContent, function(node) {
      node.contentEditable = true;
    });

    primaryEditableButton.addEventListener('click', saveChanges);
    cancelEditableButton.addEventListener('click', cancelEditable);
  }

  function saveChanges() {
    primaryEditableButton.removeEventListener('click', saveChanges);
    // Submit changes to API
    cancelEditable();
  }

  function cancelEditable() {
    cancelEditableButton.removeEventListener('click', cancelEditable);

    wrapper.classList.remove(editableWrapperClass);
    cancelEditableButton.classList.remove(visibleCancelButtonClass);

    Array.prototype.forEach.call(editableContent, function(node) {
      node.contentEditable = false;
    });

    primaryEditableButton.innerText = 'Edit App Info';
    primaryEditableButton.addEventListener('click', makeContentEditable);
  }
})();
