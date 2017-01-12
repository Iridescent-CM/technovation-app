(function submissionsPage() {
  if (!document.querySelector('[data-team-submissions]')) {
    return;
  }

  appNameAndDescription();

  function appNameAndDescription() {
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

      setTimeout(function() {
        if (!nameField.innerText) {
          nameField.focus();
        } else {
          var range = document.createRange();
          range.selectNodeContents(descriptionField);
          range.collapse(false);
          var selection = window.getSelection();
          selection.removeAllRanges();
          selection.addRange(range);
        }
      }, 0);

      enableCharCountLimitOnDescription(descriptionField);
      primaryEditableButton.addEventListener('click', saveChanges);
      cancelEditableButton.addEventListener('click', cancelChanges);
    }

    function editTempObject(e) {
      var nodeName = e.target.dataset.name,
          limit = parseInt(e.target.dataset.charLimit),
          length = e.target.innerText.length;

      if (e.target.innerText === "")
        length = 0;

      if (!isNaN(limit))
        var remaining = limit - length;

      if (isNaN(limit) || remaining >= 0) {
        tempObject[nodeName] = e.target.innerText;
      } else {
        e.target.innerText = e.target.innerText.slice(0, -1);
      }
    }

    function cloneContentObjToTempObj() {
      Object.keys(contentObj).forEach(function(key) {
        tempObject[key] = contentObj[key];
      });
    }

    function saveChanges() {
      primaryEditableButton.removeEventListener('click', saveChanges);

      var path = wrapper.dataset.updateUrl;
      var payload = {};
      payload[wrapper.dataset.objectName] = tempObject;

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
      primaryEditableButton.removeEventListener('click', saveChanges);
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

    function enableCharCountLimitOnDescription(descriptionField) {
      var selector = Array.prototype.join.call(descriptionField.classList) + " + span.char-count",
          existingCharCount = document.querySelector(selector);

      if (existingCharCount)
        existingCharCount.remove();

      var charCount = document.createElement('span');
      charCount.innerText = "Characters reminaing: " + (parseInt(descriptionField.dataset.charLimit) - descriptionField.innerText.length);
      charCount.classList.add('char-count');
      descriptionField.after(charCount);

      descriptionField.addEventListener('input', function(e) {
        var reminaing = parseInt(e.target.dataset.charLimit) - e.target.innerText.length;
        charCount.innerText = "Characters reminaing: " + reminaing;
      });
    }
  }

  $(".team-submissions__fixed-col").stick_in_parent();
})();
