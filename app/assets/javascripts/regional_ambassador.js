//= require application

document.addEventListener("turbolinks:load", function() {
  $("select.enum_filter").chosen({
    allow_single_deselect: true,
  });

  $(".accordion-toggle").on("click", function(e) {
    e.preventDefault();

    $accordion = $($(this).data("accordion"));

    $accordion.addClass('open');

    $(this).hide().next(".accordion-open").show();
  });
});
