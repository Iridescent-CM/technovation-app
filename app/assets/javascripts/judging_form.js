(function judgingForm() {
  console.log('Judge.');
  var formWrapper = document.getElementById('judging-form');
  if (!formWrapper) {
    return;
  }
  // Question type classes: radio_buttons, text
  var currentSectionIndex = 0;
  var currentQuestionIndex = 0;
  var sections = formWrapper.getElementsByClassName('judging-form__section');
  var currentSection = sections[currentSectionIndex];
  var questions = currentSection.getElementsByClassName('input');
  var currentQuestion = questions[currentQuestionIndex];

  currentSection.classList.add('judging-form__section--active');
  buildCurrentQuestion();

  function buildCurrentQuestion() {
    console.log(currentQuestion);
  }

  console.log(sections.length);

})();
