// Assumes a remote enabled form
$(document).on("change", "[data-submit-on-change] input", function() {
  $(this).submit();
});

$(document).on("ajax:beforeSend", "form[data-remote]", function() {
  $(this).find('.field_with_errors')
    .removeClass("field_with_errors")
    .find(".error")
    .remove();
})

$(document).on("ajax:success", "form[data-remote]", function(e, xhr) {
  swal.close();

  if (xhr['search_string']) {
    $(".badge.saved-search.active").removeClass("active");
    var $filterBadge = $("<a>");
    $filterBadge.text(xhr.name);
    $filterBadge.prop("href", "/regional_ambassador/saved_searches/" + xhr.id)
    $filterBadge.addClass("badge saved-search active")
    $('.saved-searches').append($filterBadge);
  }
});

$(document).on(
  "ajax:error",
  "form[data-remote]",
  function(event, xhr, status, error) {
    const $form = $(this);

    $.each(xhr.responseJSON, function(k, v) {
      var $err = $("<span>");
      $err.addClass("error");
      $err.text(v);

      const $input = $form.find("input[name*='" + k + "']"),
            $wrapper = $input.closest('p');

      if ($wrapper.length > 0) {
        $wrapper.addClass('field_with_errors').append($err);
      } else {
        var $fullErrWrapper = $("<div>"),
            $fullErr = $("<span>");

        $fullErrWrapper.addClass("field_with_errors");
        $fullErr.addClass("error");

        $fullErr.text(k + " " + v);
        $fullErrWrapper.html($fullErr);

        $input.after($fullErrWrapper);
      }
    });
  }
);
