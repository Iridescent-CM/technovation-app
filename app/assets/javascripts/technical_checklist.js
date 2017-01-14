(function technicalChecklist() {
  var studentForm = document.getElementById('student-technical-checklist-form');

  if (!studentForm) {
    return;
  }

  indicateProgress();

  // Make checkbox/textinput items pretty
  var checkboxTextInputs = document.getElementsByClassName('tc-form-group__item');

  Array.prototype.forEach.call(checkboxTextInputs, function(input) {
    // Make fancy toggles
    var checkboxLabel = input.querySelector('label.checkbox');
    var fancyToggle = document.createElement('span');

    fancyToggle.classList.add('fancy-toggle');
    checkboxLabel.insertBefore(fancyToggle, checkboxLabel.lastChild);

    // Set active/inactive class on input
    //.tc-form-group__item--inactive
    var checkbox = checkboxLabel.querySelector('input[type="checkbox"]');

    if (!checkbox.checked) {
      input.classList.add('tc-form-group__item--inactive');
    }

    checkbox.addEventListener('change', function(e) {
      if (e.target.checked) {
        input.classList.remove('tc-form-group__item--inactive');
      } else {
        input.classList.add('tc-form-group__item--inactive');
      }
    });
  });

  function indicateProgress() {
    var indicators = document.querySelectorAll('.indicator');

    indicators.forEach(function(indicator) {
      var groupName = indicator.dataset.name,
          inputGroup = document.querySelector('[data-group-name="' + groupName + '"]');

      var pointsEach = parseInt(inputGroup.dataset.pointsEach),
          possiblePoints = parseInt(inputGroup.dataset.possible),
          checkboxPoints = inputGroup.querySelectorAll('[checked=checked]').length * pointsEach;

      var filePoints = Array.prototype.map.call(inputGroup.querySelectorAll('input[type="file"]'), function(el) {
        if (el.value.length > 0 || el.parentElement.querySelector('img')) {
          return parseInt(inputGroup.dataset.pointsEach);
        } else {
          return 0;
        }
      });

      var scrShotField = inputGroup.querySelector('[data-count-needed]'),
          screenshotPoints = 0;
      if (scrShotField && parseInt(scrShotField.dataset.countNeeded) === parseInt(scrShotField.dataset.countHas))
        screenshotPoints = pointsEach;

      var totalPoints = filePoints.reduce(function(acc, p) { return acc + p; }, 0) + checkboxPoints + screenshotPoints;

      if (totalPoints === possiblePoints) {
        indicator.classList.add('complete');
        inputGroup.classList.add('complete');
      }

      var totalEl = indicator.querySelector('.total');
      indicator.querySelector('.possible').innerText = possiblePoints;
      totalEl.innerText = totalPoints;

      inputGroup.querySelectorAll('input[type="checkbox"]').forEach(function(ch) {
        ch.addEventListener('change', function(e) {
          var newTotal = inputGroup.querySelectorAll(':checked').length * pointsEach;

          if (newTotal > possiblePoints)
            return;

          if (newTotal === possiblePoints) {
            indicator.classList.add('complete');
            inputGroup.classList.add('complete');
          } else {
            indicator.classList.remove('complete');
            inputGroup.classList.remove('complete');
          }

          totalEl.innerText = newTotal;
        });
      });

      inputGroup.querySelectorAll('input[type="file"]').forEach(function(f) {
        f.addEventListener('change', function(e) {
          var points = Array.prototype.map.call(inputGroup.querySelectorAll('input[type="file"]'), function(el) {
            if (el.value.length > 0 || el.parentElement.querySelector('img')) {
              return parseInt(inputGroup.dataset.pointsEach);
            } else {
              return 0;
            }
          });

          var newTotal = points.reduce(function(acc, p) { return acc + p; }, 0) + screenshotPoints;

          if (newTotal === possiblePoints) {
            indicator.classList.add('complete');
            inputGroup.classList.add('complete');
          } else {
            indicator.classList.remove('complete');
            inputGroup.classList.remove('complete');
          }

          totalEl.innerText = newTotal;
        });
      });
    });
  }
})();
