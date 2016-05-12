//= require jquery
//= require jquery.turbolinks
//= require bootstrap-sprockets
//= require select2
//= require jquery_ujs
//= require turbolinks
//= require_tree .

(function() {
  var tabs = {
    cssSelector: '.nav-tabs a',

    handledEvent: 'click',

    init: function() {
      return $(document).on(this.handledEvent, this.cssSelector, this.showTab);
    },

    showTab: function(event) {
      event.preventDefault();
      return $(this).tab('show');
    },
  };

  return tabs.init();
})();
