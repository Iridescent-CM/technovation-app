(function() {
  var countrySelectFields = {
    eventList: 'ready page:load',

    countryFieldId: 'account_country',

    stateFieldId: 'account_state_province',

    cityFieldId: 'account_city',

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

  var accountDobFields = {
    eventList: 'ready page:load',

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
  countrySelectFields.init();
}())
