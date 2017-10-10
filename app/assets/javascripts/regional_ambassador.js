//= require application
//= require char-counter

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

  $("[data-affect-placeholder-of]").on("change", function() {
    const $field = $("#" + $(this).data("affect-placeholder-of")),
          value = $(this).val(),
          placeholder = $field.data("placeholder-" + value);

    $field.prop("placeholder", "example: " + placeholder);
  });
});
