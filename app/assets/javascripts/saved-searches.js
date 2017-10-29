$(document).on("ajax:success", ".saved-search [data-remote]", function() {
  $(this).closest(".saved-search").fadeOut(function() {
    $(this).remove();
  });
});

$(document).on("ajax:success", ".saved-searches-form[data-remote]",
  function(e, xhr) {
    swal.close();
    const $wrapper = $(".saved-searches"),
          $hint = $wrapper.find(".hint");

    if ($hint.length > 0) {
      $wrapper.html(xhr);
    } else {
      $wrapper.prepend(xhr);
    }
  }
);
