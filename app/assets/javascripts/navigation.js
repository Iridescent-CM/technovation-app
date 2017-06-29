document.addEventListener("turbolinks:load", function() {
  $('.navigation .icon-navicon').on('click', function() {
    $(this).closest('.navigation').addClass('showing-menu');
  });

  $('.navigation .icon-close').on('click', function() {
    $(this).closest('.navigation').removeClass('showing-menu');
  });
});
