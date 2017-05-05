(function() {
  geolocate();

  function geolocate() {
    if (!document.getElementById('account_city'));
      return;

    var $cityField = $("#account_city"),
        $stateField = $("#account_state_province"),
        $countryField = $("#account_country"),
        $latField = $("#account_latitude"),
        $lngField = $("#account_longitude");

    $cityField.closest('form').addClass('geocoding');

    if (!navigator.geolocation) {
      $cityField.closest('form').removeClass('geocoding');
      return;
    }

    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = position.coords.latitude,
          lng = position.coords.longitude,
          url = $cityField.data('geolocation-url') + "?lat=" + lat + "&lng=" + lng;

      $.getJSON(url, function(data) {
        $cityField.val(data.city);
        $stateField.val(data.state);
        $countryField.val(data.country);
        $countryField.trigger("chosen:updated");

        $latField.val(lat);
        lngField.val(lng);

        $cityField.closest('form').removeClass('geocoding');
      });
    }, function() {
      $cityField.closest('form').removeClass('geocoding');
    });
  }
})();
