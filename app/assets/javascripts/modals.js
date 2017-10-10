document.addEventListener("turbolinks:load", function() {
  $("[data-opens-modal]").on("click", function(e) {
    e.preventDefault();

    const modal = $('#' + $(this).data("opensModal"));

    swal({
      html: modal.find(".modal-content"),
      title: modal.data("heading") || "",
      showCloseButton: true,
      showConfirmButton: false,
      onOpen: makeClonedImageUploaderUnique,
    })

    function makeClonedImageUploaderUnique(modal) {
      const $form = $(modal).find(".new_image_uploader");

      if ($form.length > 0) {
        const $label = $form.find("label"),
              $field = $form.find("input[type=file]"),
              newId = Math.random()
                .toString(36)
                .replace(/[^a-z]+/g, '')
                .substr(0, 7);

        $field.prop("id", newId);
        $label.prop("for", newId);
      }
    }
  });

  $("[data-open-on-page-load]").each(function(_, modal) {
    swal({
      html: $(modal).find(".modal-content"),
      title: $(modal).data("heading"),
      showCloseButton: true,
      showConfirmButton: false,
      onClose: function(m) {
        const onCloseUrl = $(modal).data('onClose');
        if (onCloseUrl)
          $.post(onCloseUrl);
      },
    }).then(
      function(confirm) { },
      function(dismiss) { }
    );
  });
});
