(function() {
  $(document).ready(fadeOutInfo);

  function fadeOutInfo() {
    $(".flash").fadeIn('easein', function() {
      $(this).delay(1850).fadeOut('easein');
    });
  }
})();
