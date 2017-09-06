$(document).on("keyup", ".search-by-text", function(e) {
  if (e.keyCode === 13)
    $(this).closest('form').submit();
});
