(function dashboards() {
  var surveyModals = function() {
    var preSurveyModal = document.getElementById("pre_survery_interrupt");

    if (!preSurveyModal)
      return;

    preSurveyModal.addEventListener('modalclose', function(e) {
      var saveCloseActionUrl = preSurveyModal.dataset.saveCloseActionUrl;
      $.post(saveCloseActionUrl);
    });
  };

  surveyModals();
})();
