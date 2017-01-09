(function technicalChecklist() {
  var studentForm = document.getElementById('student-technical-checklist-form');

  if (!studentForm) {
    return;
  }

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
})();
