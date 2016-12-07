(function submissionsOnboarding() {
  var wrapper = document.getElementById('submissions-onboarding');
  if (!wrapper) {
    return;
  }
  var steps = wrapper.children;
  var stepsCount = steps.length;
  var currentStepIndex = 0;
  var currentStep = steps[currentStepIndex];

  currentStep.classList.add('submissions-onboarding-step--show');
  currentStep.addEventListener('click', goToNextStep);

  var integrityCheckbox = document.querySelector('.submissions-onboarding-step--integrity [type="checkbox"]');
  var integritySubmit = document.querySelector('.submissions-onboarding-step--integrity [type="submit"]');
  console.log(integrityCheckbox, integritySubmit);
  if (!integrityCheckbox.checked) {
    integritySubmit.disabled = true;
  }
  integrityCheckbox.addEventListener('change', function(e) {
    integritySubmit.disabled = !e.target.checked;
  });

  function goToNextStep(e) {
    if (!e.target.dataset.hasOwnProperty('nextStep')) {
      return;
    }
    currentStep.removeEventListener('click', goToNextStep);
    currentStep.classList.add('submissions-onboarding-step--hide');
    currentStep.addEventListener('animationend', function() {
      currentStep.classList.remove(
        'submissions-onboarding-step--show',
        'submissions-onboarding-step--hide'
      );
      setUpNextStep();
    });
  }

  function setUpNextStep() {
    currentStepIndex++;
    currentStep = steps[currentStepIndex];
    currentStep.classList.add('submissions-onboarding-step--show');

    if (currentStepIndex < (stepsCount - 1)) {
      currentStep.addEventListener('click', goToNextStep);
    }
  }
})();
