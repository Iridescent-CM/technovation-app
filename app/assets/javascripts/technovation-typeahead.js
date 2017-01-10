$(document).on('DOMContentLoaded', function() {
  var addressPicker = new AddressPicker();

  $('#geocoded').typeahead({
    minLength: 3,
    highlight: true,
  }, {
    displayKey: 'description',
    source: addressPicker.ttAdapter(),
  });

  addressPicker.bindDefaultTypeaheadEvent($('#geocoded'))

  $(addressPicker).on('addresspicker:selected', function (event, result) {
    var error = false;

    $('#latitude').val(result.lat());
    $('#longitude').val(result.lng());
    $('#city').val(result.nameForType('locality'));
    $('#state').val(result.nameForType('administrative_area_level_1'));
    $('#country').val(result.nameForType('country', true));

    $('.location-hidden').map(function() {
      var $input = $(this).find("label").next();

      if ($input.val() === "" || $input.val() === null) {
        error = true;
        $(this).fadeIn();
      }
    });

    if (error) {
      var $p = $("<p />").addClass("alert")
                         .text("We're sorry, but we couldn't get all of your location data automatically. Can you help us fill it in?")
                         .hide();
      $('#geocoded').after($p.fadeIn("easeOut"));
    }
  });
});

(function() {
  var substringMatcher = function(strs) {
    return function findMatches(q, cb) {
      var matches, substringRegex;

      // an array that will be populated with substring matches
      matches = [];

      // regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i');

      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          matches.push({ value: str });
        }
      });

      cb(matches);
    };
  };

  var zones = $('#account_timezone').data('source');

  $('#account_timezone').typeahead({
      minLength: 1,
      hint: true,
      highlight: true,
    }, {
      name: "Timezones",
      source: substringMatcher(zones),
    }
  );
})();
