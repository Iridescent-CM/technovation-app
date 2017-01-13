(function submissionsPage() {
  if (!document.querySelector('[data-team-submissions]')) {
    return;
  }

  appNameAndDescription();

  /**
   * App Name and Description editing
   */
  function appNameAndDescription() {
    var wrapper = document.getElementById("ts-app-description-wrapper");
    var buttonsWrapper = document.getElementById("ts-app-description-buttons-wrapper");
    var primaryEditableButton = document.getElementById("ts-primary-editable-btn");
    var cancelEditableButton = document.getElementById("ts-cancel-editable-btn");
    var editableContent = wrapper.querySelectorAll('[data-editable]');

    var wordCountEl = document.querySelector('[data-word-limit-for="app_description"]');

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
        node.addEventListener('input', editableInputHandler);
      });

      setTimeout(function() {
        // If app has no name, place cursor in the app name field
        if (!nameField.innerText) {
          nameField.focus();
        } else {
          // Otherwise place cursor at the end of the description field
          var range = document.createRange();
          range.selectNodeContents(descriptionField);
          range.collapse(false);
          var selection = window.getSelection();
          selection.removeAllRanges();
          selection.addRange(range);
        }
      }, 0);

      setDescriptionCount();

      primaryEditableButton.addEventListener('click', saveChanges);
      cancelEditableButton.addEventListener('click', cancelChanges);
    }

    function editableInputHandler(e) {
      var nodeName = e.target.dataset.name;
      var wordLimit = e.target.dataset.wordLimit;

      if (
        wordLimit &&
        stringToWordCount(e.target.innerText) > parseInt(wordLimit, 10)
      ) {
        var range = document.createRange();
        var selection = window.getSelection();
        var cursorPosition = selection.anchorOffset - 1;
        e.target.innerText = tempObject[nodeName];
        if (cursorPosition > e.target.firstChild.length) {
          cursorPosition = e.target.firstChild.length;
        }
        range.setStart(e.target.firstChild, cursorPosition);
        range.collapse(true);
        selection.removeAllRanges();
        selection.addRange(range);
      } else {
        tempObject[nodeName] = e.target.innerText;
      }

      if (wordLimit) {
        setDescriptionCount();
      }
    }

    function stringToWordCount(str) {
      return str.split(/\s+/)
        .filter(function(item) {
          return item !== '';
        })
        .length;
    }

    function setDescriptionCount() {
      var currentCount = stringToWordCount(descriptionField.innerText);
      var wordLimit = descriptionField.dataset.wordLimit;
      var currentCountPercentage = (currentCount / wordLimit) * 100;
      wordCountEl.innerText = '(Word count: ' +
        currentCount + ' / ' + wordLimit + ')';

      if (currentCountPercentage === 100) {
        wordCountEl.classList.add('ts-app-description__word-limit--max');
        wordCountEl.classList.remove('ts-app-description__word-limit--warn');
      } else if (currentCountPercentage > 70) {
        wordCountEl.classList.add('ts-app-description__word-limit--warn');
        wordCountEl.classList.remove('ts-app-description__word-limit--max');
      } else {
        wordCountEl.classList.remove('ts-app-description__word-limit--max');
        wordCountEl.classList.remove('ts-app-description__word-limit--warn');
      }
    }

    function hideDescriptionCount() {
      wordCountEl.innerHTML = '';
    }

    function cloneContentObjToTempObj() {
      Object.keys(contentObj).forEach(function(key) {
        tempObject[key] = contentObj[key];
      });
    }

    // Submit changes to API
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

      hideDescriptionCount();

      primaryEditableButton.innerText = 'Edit App Info';
      primaryEditableButton.addEventListener('click', makeContentEditable);
    }
  }

  $(".team-submissions__fixed-col").stick_in_parent();
})();
