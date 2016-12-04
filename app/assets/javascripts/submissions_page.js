(function submissionsPage() {
  if (!document.querySelector('[data-team-submissions]')) {
    return;
  }

  var wrapper = document.getElementById("ts-app-description-wrapper");
  var buttonsWrapper = document.getElementById("ts-app-description-buttons-wrapper");
  var primaryEditableButton = document.getElementById("ts-primary-editable-btn");
  var cancelEditableButton = document.getElementById("ts-cancel-editable-btn");
  var editableContent = wrapper.querySelectorAll('[data-editable]');

  var nameField = Array.prototype.find.call(editableContent, function(node) {
    return node.dataset.name === 'app_name';
  });
  var descriptionField = Array.prototype.find.call(editableContent, function(node) {
    return node.dataset.name === 'app_description';
  });

  var editableWrapperClass = 'ts-app-description--editable';
  var visibleCancelButtonClass = 'ts-app-description__cancel-btn--show';

  // actual object
  var contentObj = Array.prototype.reduce.call(editableContent, function(obj, node) {
    obj[node.dataset.name] = node.innerText;
    return obj;
  }, {});

  var tempObject = {};
  cloneContentObjToTempObj();

  primaryEditableButton.addEventListener('click', makeContentEditable);

  function makeContentEditable() {
    primaryEditableButton.removeEventListener('click', makeContentEditable);
    primaryEditableButton.innerText = 'Save Changes';

    wrapper.classList.add(editableWrapperClass);
    cancelEditableButton.classList.add(visibleCancelButtonClass);

    Array.prototype.forEach.call(editableContent, function(node) {
      node.contentEditable = true;
      node.addEventListener('input', editTempObject);
    });

    primaryEditableButton.addEventListener('click', saveChanges);
    cancelEditableButton.addEventListener('click', cancelChanges);
  }

  function editTempObject(e) {
    var nodeName = e.target.dataset.name;
    tempObject[nodeName] = e.target.innerText;
  }

  function cloneContentObjToTempObj() {
    Object.keys(contentObj).forEach((key) => {
      tempObject[key] = contentObj[key];
    });
  }

  // Submit changes to API
  function saveChanges() {
    primaryEditableButton.removeEventListener('click', saveChanges);

    var path = wrapper.dataset.updateUrl;
    var payload = {
      [wrapper.dataset.objectName]: tempObject
    }

    $.ajax(path, {
      method: 'PUT',
      data: payload,
      success: function(res, status) {
        createFlashNotification('success', 'Your app description has been updated!');
        removeContentEditable();
      },
      error: function(res, status) {
        var responseText = JSON.parse(res.responseText);
        var errorKeys = Object.keys(responseText);
        for (var i = 0; i < errorKeys.length; i++) {
          var currentError = errorKeys[i] + ' ' + responseText[errorKeys[i]];
          createFlashNotification('error', currentError);
        }
        cancelChanges();
      }
    });

  }

  function cancelChanges() {
    cancelEditableButton.removeEventListener('click', cancelChanges);

    cloneContentObjToTempObj();
    Array.prototype.forEach.call(editableContent, function(node) {
      node.innerText = contentObj[node.dataset.name];
    });

    removeContentEditable();
  }

  function removeContentEditable() {
    wrapper.classList.remove(editableWrapperClass);
    cancelEditableButton.classList.remove(visibleCancelButtonClass);

    Array.prototype.forEach.call(editableContent, function(node) {
      node.contentEditable = false;
    });
    primaryEditableButton.innerText = 'Edit App Info';
    primaryEditableButton.addEventListener('click', makeContentEditable);
  }
})();
