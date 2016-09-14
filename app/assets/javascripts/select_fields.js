(function() {
  var accountDobFields = {
    eventList: 'DOMContentLoaded',

    cssSelector: '.account_dob',

    init: function() {
      $(document).on(this.eventList, this.enableChosen.bind(this));
    },

    enableChosen: function(e) {
      $(this.cssSelector).chosen({
        disable_search_threshold: 8,
      });
    },
  };

  accountDobFields.init();
}());


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
