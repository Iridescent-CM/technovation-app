//= require jquery
//= require turbolinks

(function() {
  var registrationRoles = {
    cssSelector: '.button-group input',

    hideSelector: '.toggle-field',

    init: function() {
      this.toggleRoleFields();
      return $(document).on('change', this.cssSelector, this.toggleRoleFields.bind(this));
    },

    toggleRoleFields: function() {
      this.hideRoleFields();
      this.revealSelectedRoleFields();
    },

    revealSelectedRoleFields: function() {
      return $.each($(this.cssSelector + ':checked'), function(_, obj) {
        return $($(obj).data('reveal')).show();
      });
    },

    hideRoleFields: function() {
      $(this.hideSelector).hide();
    }
  };

  registrationRoles.init();
}())
