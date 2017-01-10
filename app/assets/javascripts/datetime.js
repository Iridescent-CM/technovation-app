(function dateTime() {
  var enableDateTimeHelper = function() {
    var startingDateTimes = document.querySelectorAll('[data-starting-date-time]');

    for (var i = 0; i < startingDateTimes.length; i++) {
      var currentStarter = startingDateTimes[i],
          currentEnder = document.getElementById(currentStarter.dataset.endingDateTimeId),
          starterInputs = currentStarter.children,
          enderInputs = currentEnder.children;

      for (var j = 0; j < starterInputs.length; j++) {
        var currentStartInput = starterInputs[j];

        if (currentStartInput.tagName === "SELECT") {
          currentStartInput.addEventListener('change', function(e) {
            var idx = Array.prototype.indexOf.call(starterInputs, e.target);
            enderInputs[idx].value = e.target.value;
          });
        }
      }
    }
  }

  enableDateTimeHelper();
})();
