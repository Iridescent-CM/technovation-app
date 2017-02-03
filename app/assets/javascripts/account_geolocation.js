(function() {
  geolocate();

  function geolocate() {
    var geocoded_field = document.querySelector("#geocoded");

    if (!navigator.geolocation || !geocoded_field)
      return;

    if (geocoded_field.value !== "")
      return;

    navigator.geolocation.getCurrentPosition(function(position) {
      var lat = position.coords.latitude,
          lng = position.coords.longitude,
          url = geocoded_field.dataset.geolocationUrl + "?lat=" + lat + "&lng=" + lng;

      $.getJSON(url, function(data) {
        geocoded_field.value = data.geocoded;
      });
    });
  }
})();
