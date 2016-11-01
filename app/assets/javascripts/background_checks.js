(function() {
  $(document).ready(initRevealSSN);

  function initRevealSSN() {
    $(document).on('keyup', '#background_check_candidate_ssn', function(e) {
      if (e.target.value.length === 0) {
        $('#show-ssn').fadeOut('easein');
      } else {
        $('#show-ssn').fadeIn('easein');
      };
    });

    $(document).on('click', '#show-ssn a', function(e) {
      e.preventDefault();

      var $reveal = $('#background_check_candidate_ssn');

      if ($reveal.attr('type') === 'text') {
        $reveal.attr('type', 'password');
        e.target.innerHTML = "Show SSN";
      } else {
        $reveal.attr('type', 'text');
        e.target.innerHTML = "Hide SSN";
      }
    });
  }
})();
