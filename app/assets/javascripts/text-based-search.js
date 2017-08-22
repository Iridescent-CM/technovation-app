document.addEventListener("turbolinks:load", function(e) {
  $(".search-by-text").on('keyup', function(e) {
    if (e.keyCode === 13)
      $(this).closest('form').submit();
  });
});
