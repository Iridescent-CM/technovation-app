//= require application
//= require cocoon
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

  $(".placeholder-updaters select").on("change", function() {
    const value = $(this).val(),
          $field = $(this).closest(".placeholder-updaters")
                          .find("[data-" + value + "]"),
          placeholder = $field.data(value);

    $field.prop("placeholder", "example: " + placeholder);
  });

  $("[data-mark-for-destroy]").on("click", function(e) {
    e.preventDefault();

    const $destroyField = $("#" + $(this).data("mark-for-destroy"));

    $destroyField.val("1");

    $destroyField.closest(".destroyable").fadeOut();
  });
});
