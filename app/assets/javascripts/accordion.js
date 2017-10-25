document.addEventListener("turbolinks:load", function() {
  $(document).on(".accordion-toggle", "click", function(e) {
    e.preventDefault();

    $accordion = $($(this).data("accordion"));

    $accordion.addClass('open');

    $(this).hide().next(".accordion-open").show();
  });
});
