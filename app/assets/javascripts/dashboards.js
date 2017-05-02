(function dashboards() {
  var surveyModals = function() {
    var surveyModal = document.getElementById("survery_interrupt") ;

    if (!surveyModal)
      return;

    surveyModal.addEventListener('modalclose', function(e) {
      var saveCloseActionUrl = surveyModal.dataset.saveCloseActionUrl;
      $.post(saveCloseActionUrl);
    });
  };

  surveyModals();
})();
