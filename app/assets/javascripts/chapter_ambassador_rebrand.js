//= require application
//= require char-counter
//= require cocoon

$(document).on("change", ".placeholder-updaters select", function () {
  const value = $(this).val().replace("_", "-"),
    $field = $(this)
      .closest(".placeholder-updaters")
      .find("[data-" + value + "]"),
    placeholder = $field.data(value);

  $field.prop("placeholder", "ex: " + placeholder);
});

$(document).on("change", ".regional-links-fields select", function () {
  const value = $(this).val(),
    $customLabel = $(this)
      .closest(".regional-links-fields")
      .find(".custom_label");

  if (value == "whatsapp_group" && $customLabel.not(":visible")) {
    $customLabel.fadeIn();
  } else if (value != "whatsapp_group" && $customLabel.is(":visible")) {
    $customLabel.fadeOut();
  }
});
