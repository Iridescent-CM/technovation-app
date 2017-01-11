(function alternativeForms() {
  var enableAltForms = function() {
    var formWrappers = document.querySelectorAll('.alternative-forms');

    Array.prototype.forEach.call(formWrappers, function(wrapper) {
      var formSwitch = wrapper.querySelector('.alternative-form-switch');

      formSwitch.addEventListener('click', function(event) {
        event.preventDefault();

        var activeForm = wrapper.querySelector('form.active'),
            activatingForm = wrapper.querySelector('form.alternative-form:not(.active)');

        activeForm.classList.remove('active');
        activatingForm.classList.add('active');

        event.target.innerHTML = activatingForm.dataset.switchText;
        event.target.blur();
      });
    });
  };

  enableAltForms();
})();
