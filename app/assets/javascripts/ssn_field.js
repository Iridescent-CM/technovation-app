(function(){
  var ssnField = {
    cssSelector: '#background_check_candidate_ssn',

    init: function() {
      return $(document).on('keyup', this.cssSelector, this.formatSsn);
    },

    formatSsn: function(e) {
      var val = this.value.replace(/\D/g, ''),
          newVal = '';

      if(val.length > 4) {
        this.value = val;
      }

      if((val.length == 3) && (val.length < 6)) {
        newVal += val.substr(0, 3) + '-';
        val = val.substr(3);
      }

      if (val.length > 5) {
        newVal += val.substr(0, 3) + '-';
        newVal += val.substr(3, 2) + '-';
        val = val.substr(5);
      }

      newVal += val;
      return this.value = newVal;
    },
  };

  ssnField.init();
}());
