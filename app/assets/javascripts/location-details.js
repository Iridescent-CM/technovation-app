$(function() {
  if ("geolocation" in navigator) {
    var $hideWhileGeocoding = $('form').children().not('.while-geocoding');

    $hideWhileGeocoding.fadeOut(function() {
      navigator.geolocation.getCurrentPosition(function(position) {
        var lat = position.coords.latitude,
            lng = position.coords.longitude,

            $cityField = $("#city"),
            $stateField = $("#state_province"),
            $countryField = $("#country"),
            $latField = $("#latitude"),
            $lngField = $("#longitude"),

            url = $cityField.data('geolocation-url');

        url += "?lat=" + lat
        url += "&lng=" + lng;

        $.getJSON(url, function(data) {
          $cityField.val(data.city);
          $stateField.val(data.state);
          $countryField.val(data.country);
          $countryField.trigger("chosen:updated");

          $latField.val(lat);
          $lngField.val(lng);

          afterGeocoding();
        });
      }, function() {
        afterGeocoding();
      });

      function afterGeocoding() {
        $('.while-geocoding').fadeOut();
        $hideWhileGeocoding.fadeIn();
      }
    });
  }
});
