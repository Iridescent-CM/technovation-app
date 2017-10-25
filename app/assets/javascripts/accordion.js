$(document).on("click", ".accordion-toggle", function(e) {
  e.preventDefault();

  const $accordion = $($(this).data("accordion"));

  $accordion.toggleClass('open');

  $(".accordion-toggle").toggleClass("hidden");
});
