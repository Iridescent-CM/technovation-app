(function judgingForm() {
  var formWrapper = document.getElementById('judging-form');
  if (!formWrapper) {
    return;
  }
  document.querySelector('.judging-form__loader').remove();
  formWrapper.classList.remove('judging-form--loading');
  var activeSectionIndex = 0;
  var activeQuestionIndex = 0;
  var sections = formWrapper.getElementsByClassName('judging-form__section');
  var activeSection = sections[activeSectionIndex];
  var questionSelector = '.input, .question-technical-checklist';
  var questions = activeSection.querySelectorAll(questionSelector);
  var activeQuestion = questions[activeQuestionIndex];
  activeQuestion.classList.add('active'); // Not BEM cause this thing is being generated dynamically
  activeSection.classList.add('judging-form__section--active');

  var backButton = document.getElementById('juding-form-button-back');
  var nextButton = document.getElementById('juding-form-button-next');
  var buttonWrappers = document.getElementsByClassName('judging-form__button-wrapper');

  backButton.addEventListener('click', goToPrevQuestion);
  nextButton.addEventListener('click', goToNextQuestion);

  var saveAllButton = document.getElementById('submit-all-forms');
  saveAllButton.addEventListener('click', saveProgressAll);
  var saveAllPending = false;
  var saveAllPendingCount = 0;
  $(document).ajaxSuccess(handleAjaxSave);

  var verifySubmissionButton = document.getElementById('verify-scores');
  verifySubmissionButton.addEventListener('click', reviewSubmissionForm);

  for (var i = 0; i < buttonWrappers.length; i++) {
    buttonWrappers[i].addEventListener('click',  function() {
      this.querySelector('button').click();
    })
  }

  setShouldButtonsBeDisabled();
  generateMarkup();
  initRangeSliders();
  setFormDisplay('minimize');

  var tcForm = document.querySelector('#judging-technical-checklist form');
  // If any of the technical checklist toggles are toggled on, we can assume
  // that the TC has been looked at
  var hasVerifiedTechnicalChecklist = (function() {
    var checkboxes = tcForm.querySelectorAll('[type="checkbox"]');
    var hasVerified = false;
    while (hasVerified === false) {
      var checkboxCount = checkboxes.length;
      for (var i = 0; i < checkboxCount; i++) {
        if (checkboxes[i].checked) {
          hasVerified = true;
        }
      }
      break;
    }
    return hasVerified;
  })();
  handleTechnicalChecklist();

  /**
   * Basic DOM structure and initial set up
   */
  function generateMarkup() {
    for (var i = 0; i < sections.length; i++) {
      var currentSection = sections[i];
      var questions = currentSection.querySelectorAll(questionSelector);

      // Sorry for the nested for loop :(
      // This is more straightforward, IMO, than functioning it out
      for (var y = 0; y < questions.length; y++) {
        var currentQuestion = questions[y];
        generateHelperInput(currentQuestion);
      }
    }
    makeBreadcrumbs();
    setActiveBreadcrumbs();
  }

  function makeBreadcrumbs() {
    var breadcrumbsWrapper = formWrapper.querySelector('.judging-form__breadcrumbs-wrapper');
    var container = document.createElement('div');
    container.classList.add('judging-form__breadcrumbs');
    for (var i = 0; i < sections.length; i++) {
      var currentSection = sections[i];
      var currentSectionName = currentSection
        .querySelector('h1')
        .innerText;
      currentSection.dataset.label = currentSectionName;
      currentSection.dataset.index = i;
      currentSection.dataset.isActive = false;
      var breadcrumb = document.createElement('div');
      breadcrumb.classList.add('judging-form__crumb');
      var labelEl = document.createElement('div');
      labelEl.classList.add('judging-form__crumb-label');
      labelEl.innerText = currentSectionName;
      breadcrumb.appendChild(labelEl);
      container.appendChild(breadcrumb);
    }
    breadcrumbsWrapper.appendChild(container);
  }

  function generateHelperInput(question) {
    if (question.classList.contains('radio_buttons')) {
      makeRadioHelper(question);
    } else if (question.classList.contains('text')) {
      makeTextareaHelper(question);
    }
  }

  function makeRadioHelper(question) {
    var radios = question.querySelectorAll('.radio input');
    var checkedValue;
    forEach(radios, function(r) {
      if (r.checked) {
        checkedValue = r.value;
      }
    });
    var inputWrapper = document.createElement('div');
    inputWrapper.classList.add('judge-helper', 'judge-helper--range');

    // Range Input
    var input = document.createElement('input');
    input.type = 'range';
    input.min = radios[0].value;
    input.max = radios[radios.length - 1].value;
    input.defaultValue = checkedValue || input.min;
    inputWrapper.appendChild(input);

    // Helper description text div
    var descriptionTextEl = document.createElement('div');
    var tickMarksWrapper = document.createElement('div');
    tickMarksWrapper.classList.add('judge-helper__tick-marks-wrapper');
    for (var i = 0; i < radios.length; i++) {
      descriptionTextEl.dataset['description-' + i] = radios[i].parentElement.textContent;
    }

    // Tick marks for range options
    for (var i = 0; i < radios.length; i++) {
      var tickMark = document.createElement('div');
      tickMark.classList.add('judge-helper__tick-mark');
      tickMarksWrapper.appendChild(tickMark);
    }

    inputWrapper.appendChild(descriptionTextEl);
    inputWrapper.appendChild(tickMarksWrapper);

    question.appendChild(inputWrapper);
  }

  function makeTextareaHelper(question) {
    var textarea = question.querySelector('textarea');
    var responseDropdown = document.createElement('select');
    var cannedResponses = question.dataset.cannedResponses;

    if (!cannedResponses) return;


    var options = JSON.parse(cannedResponses);

    var promptOption = document.createElement('option');
    promptOption.innerText = 'Choose a sentence prompt to help you get started...'
    promptOption.selected = true;
    promptOption.value = '';
    responseDropdown.appendChild(promptOption);

    options.forEach(function(option) {
      var optionEl = document.createElement('option');
      optionEl.innerText = option;
      responseDropdown.appendChild(optionEl);
    });

    responseDropdown.addEventListener('change', function(e) {
      if (e.target.value) {
        textarea.value = e.target.value;
        if (textarea.oninput) {
          textarea.oninput();
        }
      }
      this.value = '';
    });

    question.insertBefore(responseDropdown, question.lastChild);
  }

  /**
   * Form navigation
   */
  function goToPrevQuestion(e) {
    e.stopPropagation();
    saveProgress();
    questions[activeQuestionIndex].classList.remove('active');
    var isBeginningOfSection = activeQuestionIndex === 0;
    if (isBeginningOfSection) {
      activeSectionIndex = activeSectionIndex - 1;
      activeSection.classList.remove('judging-form__section--active');
      activeSection = sections[activeSectionIndex];
      activeSection.classList.add('judging-form__section--active');
      questions = activeSection.querySelectorAll(questionSelector);
      activeQuestionIndex = questions.length - 1;
    } else {
      activeQuestionIndex = activeQuestionIndex - 1;
    }
    questions[activeQuestionIndex].classList.add('active');
    setShouldButtonsBeDisabled();
    setActiveBreadcrumbs();
  }

  function goToNextQuestion(e) {
    e.stopPropagation();
    saveProgress();
    var isLastSection = Array.prototype.indexOf.call(sections, activeSection) === (sections.length - 1);
    var isEndOfSection = questions.length === (activeQuestionIndex + 1);
    if (isLastSection && isEndOfSection) {
      reviewSubmissionForm();
      return; 
    }
    questions[activeQuestionIndex].classList.remove('active');
    activeQuestionIndex = isEndOfSection ? 0 : activeQuestionIndex + 1;
    if (isEndOfSection) {
      activeSectionIndex = activeSectionIndex + 1;
      activeSection.classList.remove('judging-form__section--active');
      activeSection = sections[activeSectionIndex];
      activeSection.classList.add('judging-form__section--active');
      questions = activeSection.querySelectorAll(questionSelector);
    }
    questions[activeQuestionIndex].classList.add('active');
    setShouldButtonsBeDisabled();
    setActiveBreadcrumbs();
  }

  function saveProgress() {
    var submitButton = activeSection.querySelector('input[type="submit"]');
    if (submitButton) {
      submitButton.click();
    }
  }

  function saveProgressAll() {
    var submitButtons = formWrapper.querySelectorAll('input[type="submit"]');
    forEach(submitButtons, function(button) {
      button.click();
    });
    saveAllPending = true;
    saveAllButton.disabled = true;
  }

  function handleAjaxSave() {
    if (saveAllPending) {
      saveAllPendingCount++;

      // We compare against sections.length - 1 to account for the Technical Checklist
      if (saveAllPendingCount === (sections.length - 1)) {
        createFlashNotification('success', 'Saved successfully!', 2000);
        saveAllPendingCount = 0;
        handleSaveAll = false;
        saveAllButton.disabled = false;
      }
    } else {
      setTimeout(function() {
        createFlashNotification(['success', 'small'], 'Progress saved...', 500);
      }, 250);
    }
  }

  function setShouldButtonsBeDisabled() {
    var isFirst = activeSectionIndex === 0 && activeQuestionIndex === 0;
    backButton.disabled = isFirst;
    var isLast = activeSectionIndex === (sections.length - 1) &&
      activeQuestionIndex === (questions.length - 1);
    nextButton.disabled = isLast;

    var textarea = questions[activeQuestionIndex].querySelector('textarea');
    if (textarea && !textarea.value) {
      nextButton.disabled = true;
      textarea.oninput = function() {
        if (this.value) {
          nextButton.disabled = false;
        } else {
          nextButton.disabled = true;
        }
      };
    }

    var technicalChecklist = questions[activeQuestionIndex].classList.contains('question-technical-checklist');
    if (technicalChecklist && !hasVerifiedTechnicalChecklist) {
      nextButton.disabled = true;
    } else {
      nextButton.disabled = false;
    }
  }

  function setActiveBreadcrumbs() {
    var breadcrumbs = document.getElementsByClassName('judging-form__crumb');
    for (var i = 0; i < breadcrumbs.length; i++) {
      if (i === activeSectionIndex) {
        breadcrumbs[i].classList.add('judging-form__crumb--active');
      }
    }
  }

  /**
   * Range slider methods
   */

  function setRadioValueFromRange(range) {
    var correspondingRadio = range.$element[0]
      .parentElement
      .parentElement
      .querySelector('input[type="radio"][value="' + range.value + '"]');
    correspondingRadio.click();
  }

  function initRangeSliders() {
    $('input[type="range"]').rangeslider({
        polyfill: false,
        // Default CSS classes
        rangeClass: 'rangeslider',
        disabledClass: 'rangeslider--disabled',
        horizontalClass: 'rangeslider--horizontal',
        verticalClass: 'rangeslider--vertical',
        fillClass: 'rangeslider__fill',
        handleClass: 'rangeslider__handle',

        onInit: function() {
          // Write value to drag hhandle
          this.$handle[0].innerHTML = this.value;
          // Make tooltip
          var tooltip = document.createElement('div');
          tooltip.classList.add('rangeslider__tooltip');
          this.$range[0].parentElement.appendChild(tooltip);
          this.tooltip = tooltip;
          setRadioValueFromRange(this);
        },

        onSlide: function(position, value) {
          this.$handle[0].innerHTML = value;
          var descriptions = this.$range[0].nextElementSibling;
          var currentDescription = descriptions.dataset['description-' + value];
          this.tooltip.innerHTML = currentDescription;
          this.tooltip.classList.add('rangeslider__tooltip--active');
          this.tooltip.style.left = position + 'px';
        },

        onSlideEnd: function(position, value) {
          this.tooltip.classList.remove('rangeslider__tooltip--active');
          setRadioValueFromRange(this);
        }
    });
  }

  /**
   * Maximize, minimize, window view
   */

  var maximizeButton = document.getElementById('juding-form-maximize');
  maximizeButton.addEventListener('click', function() {
    setFormDisplay('maximize');
  });

  var windowButton = document.getElementById('juding-form-window'),
      windowButtonSecondary = document.getElementById('juding-form-window-reveal');
  _.each([windowButton, windowButtonSecondary], function(btn) {
    btn.addEventListener('click', function() {
      setFormDisplay('window');
    });
  });

  var minimizeButton = document.getElementById('juding-form-minimize');
  minimizeButton.addEventListener('click', function() {
    setFormDisplay('minimize');
  });

  var maximizeClass = 'judging-form--maximize';
  var minimizeClass = 'judging-form--minimize';

  function setFormDisplay(type) {
    if (type === 'maximize') {
      if (formWrapper.classList.contains(maximizeClass)) {
        return;
      }
      formWrapper.addEventListener('transitionend', maximizeForm);
    } else if (type === 'window') {
      if (!formWrapper.classList.contains(maximizeClass) && !formWrapper.classList.contains(minimizeClass)) {
        return;
      }
      formWrapper.addEventListener('transitionend', windowForm);
    } else if (type === 'minimize') {
      if (formWrapper.classList.contains(minimizeClass)) {
        return;
      }
      formWrapper.addEventListener('transitionend', minimizeForm);
    }

    formWrapper.classList.add('judging-form--transition');
  }

  function maximizeForm() {
    formWrapper.classList.remove(minimizeClass);
    formWrapper.classList.add(maximizeClass);
    formWrapper.querySelector("[data-show-on='minimize']").style.display = "none";
    document.body.style.overflow = 'hidden';

    formWrapper.classList.remove('judging-form--transition');
    formWrapper.removeEventListener('transitionend', maximizeForm);
    $(window).trigger('resize');
  }

  function windowForm() {
    formWrapper.classList.remove(maximizeClass);
    formWrapper.classList.remove(minimizeClass);
    formWrapper.querySelector("[data-show-on='minimize']").style.display = "none";
    document.body.style.overflow = 'auto';

    formWrapper.classList.remove('judging-form--transition');
    formWrapper.removeEventListener('transitionend', windowForm);
    $(window).trigger('resize');
  }

  function minimizeForm() {
    formWrapper.classList.remove(maximizeClass);
    formWrapper.classList.add(minimizeClass);
    formWrapper.querySelector("[data-show-on='minimize']").style.display = "block";
    document.body.style.overflow = 'auto';

    formWrapper.classList.remove('judging-form--transition');
    formWrapper.removeEventListener('transitionend', minimizeForm);
  }

  /**
   * Technical checklist step
   */

  function handleTechnicalChecklist() {
    // Make Checkboxes Fancy Again
    var checkboxes = document.getElementsByClassName('judging-tc-modal__checkbox-wrapper');
    var labelSpanClass = 'judging-tc-modal__label-text';
    for (var i = 0; i < checkboxes.length; i++) {
      var fancyToggle = document.createElement('span');
      fancyToggle.classList.add('fancy-toggle');
      var checkbox = checkboxes[i].querySelector('[type="checkbox"]');
      var label = checkbox.parentElement;
      var labelText = checkbox.parentElement.innerText;
      var labelSpan = document.createElement('span');
      labelSpan.innerText = labelText;
      labelSpan.classList.add(labelSpanClass);
      label.lastChild.remove();
      label.appendChild(fancyToggle);
      label.appendChild(labelSpan);
    }

    // If user is on touch device, change copy on the technical checklist label toggles
    function handleDetectTouch() {
      var labelSpans = document.getElementsByClassName(labelSpanClass);
      for (var i = 0; i < labelSpans.length; i++) {
        labelSpans[i].innerText = 'Tap to Verify';
      }
      var figCaptions = document.querySelectorAll('.judging-tc-modal__image-wrapper figcaption');
      for (var i = 0; i < figCaptions.length; i++) {
        figCaptions[i].innerText = 'Tap to expand';
      }
      window.removeEventListener('touchstart', handleDetectTouch);
    };
    window.addEventListener('touchstart', handleDetectTouch);

    // Paper prototype/flow chart image expand
    setTimeout(function() {
      var imageFigures = document.querySelectorAll('.judging-tc-modal__image-wrapper figure');
      for (var i = 0; i < imageFigures.length; i++) {
        var figure = imageFigures[i];
        figure.addEventListener('click', maximizeImage);
      }
    }, 0);

    function maximizeImage(e) {
      var figure = e.currentTarget;
      var positionerWrapper = document.createElement('div');
      positionerWrapper.classList.add('judging-tc-fullscreen-image');
      var contentWrapper = document.createElement('div');
      contentWrapper.classList.add('judging-tc-fullscreen-image__content');
      var closeButtonWrapper = document.createElement('div');
      closeButtonWrapper.classList.add('judging-tc-fullscreen-image__close-button-wrapper');
      var closeButton = document.createElement('span');
      closeButton.classList.add('fa', 'fa-times');
      closeButtonWrapper.appendChild(closeButton);
      var pseudoImageElement = document.createElement('div');
      pseudoImageElement.classList.add('judging-tc-fullscreen-image__pseudo-img');
      pseudoImageElement.style.backgroundImage = 'url("' + figure.firstElementChild.src + '")';
      contentWrapper.appendChild(closeButtonWrapper);
      contentWrapper.appendChild(pseudoImageElement);
      positionerWrapper.appendChild(contentWrapper);
      document.body.appendChild(positionerWrapper);

      closeButton.addEventListener('click', function() {
        positionerWrapper.remove();
      });
    }

    setTimeout(function() {
      var tcSubmitButton = document.querySelector('#judging-technical-checklist [type="submit"]');
      tcSubmitButton.addEventListener('click', submitTechnicalChecklist);
    }, 0);
    // AJAX submit Technical Checklist
    function submitTechnicalChecklist(e) {
      e.preventDefault();
      var form = $(e.target).closest('form')[0];

      $.ajax({
        method: 'POST',
        url: form.action,
        data: $(form).serialize(),
        success: function(data) {
          hasVerifiedTechnicalChecklist = true;
          setShouldButtonsBeDisabled();
        },
        error: function(err) {
          console.error(err);
        }
      });
    }
  }

  /**
   * Review submission form
   */
  function reviewSubmissionForm() {
    var submissionVerification = verifySubmission();
    if (submissionVerification.isValid) {
      createVerificationView();
    } else {
      createFlashNotification('error', submissionVerification.error, 4000);
    }
  }

  function verifySubmission() {
    if (!hasVerifiedTechnicalChecklist) {
      return {
        isValid: false,
        error: 'Please review the Technical Checklist before continuing'
      };
    }
    var allSectionsHaveComments = true;
    forEach(sections, function(section) {
      if (section.querySelector('textarea') && !section.querySelector('textarea').value) {
        allSectionsHaveComments = false;
      }
    });
    if (!allSectionsHaveComments) {
      return {
        isValid: false,
        error: 'Please ensure all sections have a valid comment'
      };
    }
    // If we're down here, everything is valid
    return {isValid: true};
  }

  function createVerificationView() {
    var modalId = 'judging-submission-review';
    var submissionModal = document.getElementById(modalId);
    var modalBody = submissionModal.querySelector('.modalify__body');
    var wraperClass = 'verify-submission__wrapper';
    // If we have content, destroy it
    if (modalBody.getElementsByClassName(wraperClass).length > 0) {
      modalBody.getElementsByClassName(wraperClass)[0].remove();
    }

    var sectionsToRender = document.createElement('div');
    sectionsToRender.classList.add(wraperClass);

    for (var i = 0; i < sections.length; i++) {
      var section = sections[i];
      var form = section.querySelector('form');
      var sectionWrapper = document.createElement('div');
      var headerText = section.querySelector('h1').innerText;
      var header = document.createElement('h2');
      header.classList.add('verify-submission__header', 'appy-title');
      header.innerText = headerText;
      sectionWrapper.appendChild(header);
      var items = [];
      if (form) {
        var inputs = form.getElementsByClassName('input');
        for (var c = 0; c < inputs.length; c++) {
          var label = document.createElement('p');
          var value = document.createElement('p');
          label.classList.add('verify-submission__label');
          value.classList.add('verify-submission__value');
          var current = inputs[c];
          label.innerText = current.querySelector('label').innerText;
          var inputType = current.querySelector('input:checked') ? 'checkbox' : 'textarea';
          value.innerText = inputType === 'checkbox'
            ? current.querySelector('input:checked').nextSibling.textContent
            : current.querySelector('textarea').value;
          sectionWrapper.appendChild(label);
          sectionWrapper.appendChild(value);
        }
      } else {
        // Technical Checklist
        var label = document.createElement('p');
        var value = document.createElement('p');
        label.classList.add('verify-submission__label');
        value.classList.add('verify-submission__value');
        var checkedCount = tcForm.querySelectorAll('input[type="checkbox"]:checked').length;
        var totalCount = tcForm.querySelectorAll('input[type="checkbox"]').length;
        label.innerText = 'Number of technical checklist items verified:';
        value.innerText = checkedCount + ' out of ' + totalCount;
        sectionWrapper.appendChild(label);
        sectionWrapper.appendChild(value);
      }
      sectionsToRender.appendChild(sectionWrapper);
    }

    var buttonsWrapper = document.createElement('div');
    buttonsWrapper.classList.add('verify-submission__buttons-wrapper');
    var submitButton = document.createElement('button');
    buttonsWrapper.appendChild(submitButton);
    submitButton.classList.add('appy-button');
    submitButton.innerText = 'Submit Scores';

    submitButton.addEventListener('click', function() {
      $.ajax({
        method: "PATCH",
        url: formWrapper.dataset.url,
        data: {
          submission_score: {
            completed_at: new Date(),
          },
        },
        success: function() {
          location.href = formWrapper.dataset.successUrl;
        },
        error: function(data) {
          createFlashNotification('error', data.errorMessage);
        },
      });
    });

    sectionsToRender.appendChild(buttonsWrapper);

    modalBody.appendChild(sectionsToRender);

    showModal(modalId);
  }
})();
