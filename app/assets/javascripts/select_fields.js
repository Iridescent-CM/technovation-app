(function initSelectFields() {
  document.addEventListener('DOMContentLoaded', function() {
    initCountrySelect();
    initChosenDOB();
    initChosenGenderSelect();
    initRASinceYear();
    enableToggleFields();
  });

  function initCountrySelect() {
    CountryStateSelect({
      chosen_ui: true,
      chosen_options: {
        disable_search_threshold: 10,
      },
      country_id: 'country',
    });
  }

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
        disable_search_threshold: 20
      })
      .change(function() {
        setHasVal(this);
      });
  }

  function initChosenGenderSelect() {
    $('[id$="account_gender"]')
      .chosen({
        disable_search_threshold: 20
      })
      .change(function() {
        setHasVal(this);
      });
  }

  function initRASinceYear() {
    $('#regional_ambassador_account_regional_ambassador_profile_attributes_ambassador_since_year')
    .chosen({
      disable_search_threshold: 20
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

  function enableToggleFields() {
    var $selectField = $('[data-toggle="true"]');
    toggleFields({ target: $selectField });
    $selectField.on('change', toggleFields);

    function toggleFields(e) {
      var $field = $(e.target);
      var $toggleField = $($field.data("toggle-reveal"));
      var selectedValue = $field.val();
      var toggleValue = $field.data("toggle-value");

      if (toggleValue === selectedValue) {
        $toggleField.show();
      } else {
        $toggleField.hide();
        $toggleField[0].querySelector('input[type="text"]').value = '';
      }
    }
  }
})();
