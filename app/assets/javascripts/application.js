//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require chosen-jquery
//= require country_state_select
//= require turbolinks

(function() {
  var countrySelectFields = {
    eventList: 'ready page:load',

    countryFieldId: 'account_country',

    stateFieldId: 'account_region',

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

  countrySelectFields.init();
}())
