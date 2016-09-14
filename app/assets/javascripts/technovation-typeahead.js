$(document).on('turbolinks:load', function() {
  var addressPicker = new AddressPicker();

  $('#geocoded').typeahead(null, {
    displayKey: 'description',
    source: addressPicker.ttAdapter()
  });

  addressPicker.bindDefaultTypeaheadEvent($('#geocoded'))

  $(addressPicker).on('addresspicker:selected', function (event, result) {
    $('#latitude').val(result.lat());
    $('#longitude').val(result.lng());
    $('#city').val(result.nameForType('locality'));
    $('#state').val(result.nameForType('administrative_area_level_1'));
    $('#country').val(result.nameForType('country', true));
  });
});
