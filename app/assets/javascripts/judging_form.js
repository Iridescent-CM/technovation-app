(function judgingForm() {
  var formWrapper = document.getElementById('judging-form');
  if (!formWrapper) {
    return;
  }
  // Todo: Figure out what the active question/section is by looking
  // at what sections have valid inputs already
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

  for (var i = 0; i < buttonWrappers.length; i++) {
    buttonWrappers[i].addEventListener('click',  function() {
      this.querySelector('button').click();
    })
  }

  setShouldButtonsBeDisabled();

  generateMarkup();
  initRangeSliders();
  handleTechnicalChecklist();

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
    var sectionsWrapper = formWrapper.getElementsByClassName('judging-form__sections-wrapper')[0];
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
    sectionsWrapper.insertBefore(container, sectionsWrapper.firstElementChild);
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
    var inputWrapper = document.createElement('div');
    inputWrapper.classList.add('judge-helper', 'judge-helper--range');

    // Range Input
    var input = document.createElement('input');
    input.type = 'range';
    input.min = radios[0].value;
    input.max = radios[radios.length - 1].value;
    input.defaultValue = input.min;
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
    var defaultOption = document.createElement('option');
    defaultOption.innerText = 'Something something canned responses...';
    defaultOption.selected = true;
    defaultOption.value = '';
    responseDropdown.appendChild(defaultOption);
    var options = [
      'Curabitur est gravida et libero vitae dictum.',
      'At nos hinc posthac, sitientis piros Afros.',
      'Fabio vel iudice vincam, sunt in culpa qui officia.',
      'Vivamus sagittis lacus vel augue laoreet rutrum faucibus.'
    ];
    options.forEach(function(option) {
      var optionEl = document.createElement('option');
      optionEl.innerText = option;
      responseDropdown.appendChild(optionEl);
    });
    responseDropdown.addEventListener('change', function(e) {
      if (e.target.value) {
        textarea.value = e.target.value;
        textarea.oninput();
      }
      this.value = '';
    });

    question.insertBefore(responseDropdown, question.lastChild);
  }

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
      console.log('We are at the end');
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
    submitButton.click();
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
    if (technicalChecklist) {
      nextButton.disabled = true;
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

  function handleTechnicalChecklist() {
    setTimeout(function() {
      var tempCompleteButton = document.getElementById('complete-technical-checklist');
      tempCompleteButton.addEventListener('click', function() {
        nextButton.disabled = false;
        tempCompleteButton.parentElement.querySelector('.modalify__close').click();
      });
    }, 0);
  }
})();
