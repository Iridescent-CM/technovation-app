document.addEventListener("turbolinks:load", function() {
  $(".chosen").chosen();

  $(".chosen").not(".dob_field")
    .next('.chosen-container')
    .prop('style', 'width: 100%');

  $(".dob_field").next('.chosen-container')
    .prop('style', 'width: 30%');
});
