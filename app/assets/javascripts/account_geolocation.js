(function() {
  geolocate();

  function geolocate() {
    var geocoded_field = document.querySelector("#geocoded"),
        country_field = document.querySelector("#country"),
        lat_field = document.querySelector("#latitude"),
        lng_field = document.querySelector("#latitude");

    if (!navigator.geolocation || !geocoded_field)
      return;

    if (geocoded_field.value !== "")
      return;

    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = position.coords.latitude,
          lng = position.coords.longitude,
          url = geocoded_field.dataset.geolocationUrl + "?lat=" + lat + "&lng=" + lng;

      $.getJSON(url, function(data) {
        $('#geocoded').typeahead('val', data.geocoded); // REQUIRED for typeahead compatibility
        country_field.value = data.country;
        lat_field.value = lat;
        lng_field.value = lng;
      });
    });
  }
})();
