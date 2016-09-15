$(document).on('DOMContentLoaded', function() {
  var addressPicker = new AddressPicker();

  $('#geocoded').typeahead(null, {
    displayKey: 'description',
    source: addressPicker.ttAdapter()
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
      if ($(this).val() === "") {
        error = true;
        var $label = $("<label />").text(this.id);
        $(this).prop({ type: "text" }).before($label);
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
