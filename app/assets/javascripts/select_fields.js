(function() {
  var accountDobFields = {
    eventList: 'turbolinks:load',

    cssSelector: '.account_dob',

    init: function() {
      return $(document).on(this.eventList, this.enableChosen.bind(this));
    },

    enableChosen: function(e) {
      return $(this.cssSelector).chosen({
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
      return $(document).on('turbolinks:load', this.enableToggleFields.bind(this));
    },

    enableToggleFields: function(e) {
      var $selectField = $(this.cssSelector);
      this.toggleFields({ target: $selectField });
      return $selectField.on('change', this.toggleFields);
    },

    toggleFields: function(e) {
      var $field = $(e.target),
          $toggleField = $($field.data("toggle-reveal")),
          selectedValue = $field.val(),
          toggleValue = $field.data("toggle-value");

      if (toggleValue === selectedValue) {
        return $toggleField.show();
      } else {
        return $toggleField.hide();
      }
    },
  };

  toggleFields.init();
}());
