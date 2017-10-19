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

  if ($(".icon-picker").length > 0) {
    window.iconPicker = {
      imageSrc: $("#profile-image").attr("src"),

      selectedIconSrc: $(".icon-picker .selected").attr("src"),

      updateSelection: function(iconSrc, imageSrc) {
        imageSrc = imageSrc || iconSrc;

        $("#profile-image").attr("src", imageSrc);

        $(".icon-picker .selected").removeClass("selected");

        $(".icon-picker img[src='" + iconSrc + "']").addClass("selected");
      },

      resetSelection: function() {
        window.iconPicker.updateSelection(
          window.iconPicker.selectedIconSrc,
          window.iconPicker.imageSrc
        );
      },

      onModalClose: function() {
        window.iconPicker.resetSelection();
      },
    };
  }

  $(document).on("click", ".icon-picker img", function() {
    window.iconPicker.updateSelection($(this).attr("src"));
    $(this).closest(".icon-picker").siblings(".save-icon").fadeIn();
  });

  $(document).on("click", ".save-icon", function() {
    const $picker = $(this).siblings(".icon-picker"),
          paramRoot = $picker.data("update-param-root"),
          paramChild = $picker.data("update-param-child"),
          selectedIconSrc = $picker.find(".selected").attr("src");

    var data = {};

    data[paramRoot] = {};
    data[paramRoot][paramChild] = {
      id: $picker.data("update-param-child-id"),
      icon_path: selectedIconSrc,
    };

    $.ajax({
      method: "PATCH",
      url: $picker.data("update-url"),
      data: data,
      success: function() {
        window.iconPicker.imageSrc = selectedIconSrc;
        window.iconPicker.selectedIconSrc = selectedIconSrc;
        swal.close();
      },
    });
  });
});
