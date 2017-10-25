//= require application
//= require cocoon

//= require accordion
//= require char-counter

document.addEventListener("turbolinks:load", function() {
  $("select.enum_filter").chosen({
    allow_single_deselect: true,
  });
});

$(document).on("change", ".placeholder-updaters select", function() {
  const value = $(this).val(),
        $field = $(this).closest(".placeholder-updaters")
                        .find("[data-" + value + "]"),
        placeholder = $field.data(value);

  $field.prop("placeholder", "example: " + placeholder);
});
