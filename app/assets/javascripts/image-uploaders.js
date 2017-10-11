document.addEventListener("turbolinks:load", function() {
  $(document).on("change", ".file-field input", function() {
    var $form = $(this).closest('form'),
        $preview = $form.find('.preview');

    $form.find('.submit.hidden').removeClass('hidden');

    var reader = new FileReader();

    reader.onload = function(e) {
      $preview.removeClass("hidden")
        .find(".preview__img img")
        .prop('src', e.target.result)
        .prop('width', 100);
    }.bind(this);

    reader.readAsDataURL($(this).prop('files')[0]);
  });

  $(document).on("click", ".preview__img .remove", function() {
    var $form = $(this).closest('form');

    $form.find(".preview").addClass("hidden");
    $form.find('.submit').addClass('hidden');
    $form.find('input[type=file]').val('');
  });
});
