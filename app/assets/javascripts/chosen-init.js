document.addEventListener("DOMContentLoaded", function() {
  $(".chosen, select.enum_filter").chosen({
    allow_single_deselect: true,
  });

  $(".chosen").not(".dob_field")
    .next('.chosen-container')
    .prop('style', 'width: 100%');

  $(".dob_field").next('.chosen-container')
    .prop('style', 'width: 30%');
});
