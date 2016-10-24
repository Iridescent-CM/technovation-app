(function() {
  var countrySelectFields = {
    eventList: 'ready',

    countryFieldId: 'country',

    init: function() {
      return $(document).on(this.eventList, this.initCountrySelect.bind(this));
    },

    initCountrySelect: function(e) {
      return CountryStateSelect({
        chosen_ui: true,
        chosen_options: {
          disable_search_threshold: 10,
        },
        country_id: this.countryFieldId,
      });
    },
  };

  countrySelectFields.init();
}());

/*
 * Account sign-up date of birth and how did you hear about us <select> inputs
 */
(function() {
  $(document).on('DOMContentLoaded', initChosenDOB);

  function initChosenDOB() {
    $('.account_dob')
      .chosen({
        disable_search_threshold: 8
      })
      .change(function() {
        setHasVal(this);
      });

    $('.sign-up-referred-by')
      .chosen({
        disable_search_threshold: 20,
        width: '50%'
      })
      .change(function() {
        setHasVal(this);
      });
  }

  function setHasVal(select) {
    if (select.value === "") {
      select.classList.remove('has-val');
    } else {
      select.classList.add('has-val');
    }
  }
})();

(function() {
  var toggleFields = {
    cssSelector: '[data-toggle="true"]',

    init: function() {
      $(document).on('DOMContentLoaded', this.enableToggleFields.bind(this));
    },

    enableToggleFields: function(e) {
      var $selectField = $(this.cssSelector);
      this.toggleFields({ target: $selectField });
      $selectField.on('change', this.toggleFields);
    },

    toggleFields: function(e) {
      var $field = $(e.target),
          $toggleField = $($field.data("toggle-reveal")),
          selectedValue = $field.val(),
          toggleValue = $field.data("toggle-value");

      if (toggleValue === selectedValue) {
        $toggleField.show();
      } else {
        $toggleField.hide();
      }
    },
  };

  toggleFields.init();
}());
