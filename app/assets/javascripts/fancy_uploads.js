(function() {
  var fancyUploads = {
    buttonCssSelector: '[data-uploader=true]',

    parentCssSelector: 'form',

    inputCssSelector: 'input[type="file"][data-fancy=true]',

    init: function() {
      return $(document).on('click', this.buttonCssSelector, this.browseFiles.bind(this))
                        .on('change', this.inputCssSelector, this.submitForm.bind(this));
    },

    browseFiles: function(e) {
      e.preventDefault();
      return $(e.target).closest(this.parentCssSelector)
                        .find(this.inputCssSelector)
                        .trigger('click');
    },

    submitForm: function(e) {
      return $(e.target).closest(this.parentCssSelector).submit();
    }
  };

  fancyUploads.init();
})();
