document.addEventListener("turbolinks:load", function() {
  $(".file-field input").on('change', function() {
    var $preview = $(this).closest('form').find('.preview');

    $(this).closest('form').find('.submit.hidden').removeClass('hidden');

    var reader = new FileReader();

    reader.onload = function(e) {
      $preview.removeClass("hidden")
        .find(".preview__img img")
        .prop('src', e.target.result)
        .prop('width', 100);
    }.bind(this);

    reader.readAsDataURL($(this).prop('files')[0]);
  });

  $(".preview__img .remove").on("click", function() {
    $(this).closest(".preview").addClass("hidden");
    $(this).closest('form').find('.submit').addClass('hidden');
  });
});
