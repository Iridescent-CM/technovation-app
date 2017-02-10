(function() {
  geolocate();

  function geolocate() {
    var cityField = document.querySelector("#account_city"),
        stateField = document.querySelector("#account_state_province"),
        countryField = document.querySelector("#account_country"),
        latField = document.querySelector("#account_latitude"),
        lngField = document.querySelector("#account_longitude");

    if (!cityField)
      return;

    cityField.closest('form').classList.add('geocoding');

    if (!navigator.geolocation) {
      cityField.closest('form').classList.remove('geocoding');
      return;
    }

    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = position.coords.latitude,
          lng = position.coords.longitude,
          url = cityField.dataset.geolocationUrl + "?lat=" + lat + "&lng=" + lng;

      $.getJSON(url, function(data) {
        cityField.value = data.city;
        stateField.value = data.state;
        countryField.value = data.country;

        latField.value = lat;
        lngField.value = lng;

        cityField.closest('form').classList.remove('geocoding');
      });
    });
  }
})();
