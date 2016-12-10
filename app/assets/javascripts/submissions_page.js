(function submissionsPage() {
  if (!document.querySelector('[data-team-submissions]')) {
    return;
  }

  appNameAndDescription();
  ajaxFormHandler();

  function ajaxFormHandler() {
    var ajaxForms = document.querySelectorAll('[data-ajax-form]');
    if (ajaxForms.length === 0) {
      return;
    }

    for (var i = 0; i < ajaxForms.length; i++) {
      (function() {
        var wrapper = ajaxForms[i];
        var path = wrapper.dataset.updateUrl;
        var editButton = wrapper.querySelector('[data-action="edit"]');
        var objectName = wrapper.dataset.objectName;
        var namedInputs = wrapper.querySelectorAll('[name]');
        if (!path || !editButton) {
          throw new Error(
            'AJAX Forms must have an updateUrl data attribute, an edit button, '
            + 'an objectName (root param), and at least one named input'
          );
          return;
        }

        var currentData = {};
        Array.prototype.forEach.call(namedInputs, function(input) {
          currentData[input.name] = input.value;
        });

        editButton.addEventListener('click', editMode);

        var cancelButton;

        function editMode() {
          // General setup
          wrapper.classList.add('ajax-form--edit-mode');
          editButton.removeEventListener('click', editMode);

          // Turns Edit button into Save button
          editButton.innerText = 'Save';
          editButton.addEventListener('click', saveChanges);

          // Cancel button
          cancelButton = document.createElement('button');
          cancelButton.classList.add('appy-button');
          cancelButton.innerText = 'Cancel';
          editButton.parentElement.insertBefore(cancelButton, editButton);
          cancelButton.addEventListener('click', cancelEdit);
        }

        function saveChanges() {
          editButton.removeEventListener('click', saveChanges);

          var latestData = {};
          Array.prototype.forEach.call(namedInputs, function(input) {
            latestData[input.name] = input.value;
          });

          console.log('THE DATA IS ', latestData);

          var payload = {};
          payload[objectName] = latestData;

          $.ajax(path, {
            method: 'PUT',
            data: payload,
            success: function(res, status) {
              createFlashNotification('success', 'We did the thing');
              currentData = latestData;
              exitEditMode();
            },
            error: function(res, status) {
              var responseText = JSON.parse(res.responseText);
              var errorKeys = Object.keys(responseText);
              for (var i = 0; i < errorKeys.length; i++) {
                var currentError = errorKeys[i] + ' ' + responseText[errorKeys[i]];
                createFlashNotification('error', currentError);
              }
              cancelEdit();
            }
          });
        }

        function cancelEdit() {
          cancelButton.removeEventListener('click', cancelEdit);
          exitEditMode();
        }

        function exitEditMode() {
          // Cleanup
          cancelButton.remove();
          wrapper.classList.remove('ajax-form--edit-mode');
          editButton.innerText = 'Edit';
          editButton.removeEventListener('click', saveChanges);
          editButton.addEventListener('click', editMode);

          console.log(JSON.stringify(currentData));

          // Parse the inputs and update the content of the static placeholders
          Object.keys(currentData).forEach(function(name) {
            var staticEl = wrapper.querySelector('[data-display-for="' + name +'"]');
            if (!staticEl) {
              return;
            }
            var currentInput = wrapper.querySelector('[name="' + name + '"]');
            var value = currentData[name];
            // debugger;
            if (!value) {
              return;
            }
            var valueText;
            if (currentInput.tagName === 'SELECT') {
              valueText = currentInput.querySelector('[value="' + value + '"]').innerText;
            } else {
              valueText = value;
            }
            staticEl.innerText = valueText;
            console.log(value, valueText);
          });
        }
      })();
    }
  }











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

    descriptionField.addEventListener('paste', function(e) {
      var data = e.clipboardData;
      var string = data.getData('text/plain');
      var wordLimit = e.target.dataset.wordLimit;
      if (stringToWordCount(string) > wordLimit) {
        createFlashNotification('error', 'Your App Description must be ' + wordLimit + ' words or less');
        return;
      }

      e.preventDefault();
      document.execCommand('insertHTML', false, string);
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
        createFlashNotification('error', 'Your App Description must be ' + wordLimit + ' words or less');
        if (e.target.firstChild) {
          if (cursorPosition > e.target.firstChild.length) {
            cursorPosition = e.target.firstChild.length;
          }
          range.setStart(e.target.firstChild, cursorPosition);
          range.collapse(true);
          selection.removeAllRanges();
          selection.addRange(range);

        }
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
})();

(function() {
  $(".team-submissions__fixed-col, .technical-checklist__progress .simple-card")
    .stick_in_parent();
})();
