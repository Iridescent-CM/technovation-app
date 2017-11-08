//= require application
//= require cocoon
//= require Chart.min

//= require accordion
//= require char-counter
//= require forms
//= require saved-searches
//= require charts
//= require jobs

document.addEventListener("turbolinks:load", function() {
  $("select.enum_filter").chosen({
    allow_single_deselect: true,
  });
});

$(document).on("change", ".placeholder-updaters select", function() {
  const value = $(this).val().replace("_", "-"),
        $field = $(this).closest(".placeholder-updaters")
                        .find("[data-" + value + "]"),
        placeholder = $field.data(value);

  $field.prop("placeholder", "ex: " + placeholder);
});

$(document).on("change", ".regional-links-fields select", function() {
  const value = $(this).val(),
        $customLabel = $(this).closest(".regional-links-fields")
                              .find(".custom_label");

  if (value == "whatsapp_group" && $customLabel.not(":visible")) {
    $customLabel.fadeIn();
  } else if (value != "whatsapp_group" && $customLabel.is(":visible")) {
    $customLabel.fadeOut();
  }
});
