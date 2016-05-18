(function() {
  var contentToggle = {
    cssSelector: '[data-toggle="content"]',

    init: function() {
      return $(document).on('click',
                            this.cssSelector,
                            this.toggleTargetContent.bind(this));
    },

    toggleTargetContent: function(event) {
      event.preventDefault();
      this.toggleContent(event);
      return this.updateActionText(event);
    },

    toggleContent: function(event) {
      var hrefParts = event.target.href.split(/#/),
          targetId = hrefParts[hrefParts.length - 1],
          target = $('#' + targetId);

      return target.toggleClass('show');
    },

    updateActionText: function(event) {
      var linkText = event.target.text,
          actionText = linkText.match(/^\w+/)[0];

      switch(actionText) {
        case 'Show':
          return event.target.text = linkText.replace(/^\w+/, 'Hide');
        case 'Hide':
          return event.target.text = linkText.replace(/^\w+/, 'Show');
      };
    },
  };

  contentToggle.init();
})();
