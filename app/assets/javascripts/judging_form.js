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
  var questions = activeSection.getElementsByClassName('input');
  var activeQuestion = questions[activeQuestionIndex];
  activeQuestion.classList.add('active'); // Not BEM cause this thing is being generated dynamically
  activeSection.classList.add('judging-form__section--active');

  var backButton = document.getElementById('juding-form-button-back');
  var nextButton = document.getElementById('juding-form-button-next');

  backButton.addEventListener('click', goToPrevQuestion);
  nextButton.addEventListener('click', goToNextQuestion);
  setShouldButtonsBeDisabled();

  generateMarkup();
  initRangeSliders();

  function generateMarkup() {
    for (var i = 0; i < sections.length; i++) {
      var currentSection = sections[i];
      var questions = currentSection.getElementsByClassName('input');

      // Sorry for the nested for loop :(
      // This is more straightforward, IMO, than functioning it out
      for (var y = 0; y < questions.length; y++) {
        var currentQuestion = questions[y];
        generateHelperInput(currentQuestion);
      }
    }
  }

  function generateHelperInput(question) {
    var helper = question.classList.contains('radio_buttons')
      ? makeRadioHelper(question)
      : makeTextareaHelper(question);

    question.appendChild(helper);
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
    for (var i = 0; i < radios.length; i++) {
      descriptionTextEl.dataset['description-' + i] = radios[i].parentElement.textContent;
    }
    inputWrapper.appendChild(descriptionTextEl);

    return inputWrapper;
  }

  function makeTextareaHelper(question) {
    var inputWrapper = document.createElement('div');
    inputWrapper.classList.add('judge-helper', 'judge-helper--textarea');
    return inputWrapper;
  }

  function goToPrevQuestion() {
    questions[activeQuestionIndex].classList.remove('active');
    var isBeginningOfSection = activeQuestionIndex === 0;
    if (isBeginningOfSection) {
      activeSectionIndex = activeSectionIndex - 1;
      activeSection.classList.remove('judging-form__section--active');
      activeSection = sections[activeSectionIndex];
      activeSection.classList.add('judging-form__section--active');
      questions = activeSection.getElementsByClassName('input');
      activeQuestionIndex = questions.length - 1;
    } else {
      activeQuestionIndex = activeQuestionIndex - 1;
    }
    questions[activeQuestionIndex].classList.add('active');
    setShouldButtonsBeDisabled();
  }

  function goToNextQuestion() {
    questions[activeQuestionIndex].classList.remove('active');
    var isEndOfSection = questions.length === (activeQuestionIndex + 1);
    activeQuestionIndex = isEndOfSection ? 0 : activeQuestionIndex + 1;
    if (isEndOfSection) {
      activeSectionIndex = activeSectionIndex + 1;
      activeSection.classList.remove('judging-form__section--active');
      activeSection = sections[activeSectionIndex];
      activeSection.classList.add('judging-form__section--active');
      questions = activeSection.getElementsByClassName('input');
    }
    questions[activeQuestionIndex].classList.add('active');
    setShouldButtonsBeDisabled();
  }

  function setShouldButtonsBeDisabled() {
    var isFirst = activeSectionIndex === 0 && activeQuestionIndex === 0;
    backButton.disabled = isFirst;
    var isLast = activeSectionIndex === (sections.length - 1) &&
      activeQuestionIndex === (questions.length - 1);
    nextButton.disabled = isLast;
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

})();
