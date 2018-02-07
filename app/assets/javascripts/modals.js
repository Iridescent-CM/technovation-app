$(document).on("click", ".modal-content .close", function(e) {
  e.preventDefault();
  swal.close();
});

$(document).on(
  "submit",
  ".modal-content form:not([data-remote])",
  function() {
    swal.close();
  }
);

$(document).on("click", "[data-opens-modal]", function(e) {
  e.preventDefault();

  const modal = $('#' + $(this).data("opensModal")),
        that = this;

  swal({
    html: modal.find(".modal-content"),
    width: modal.data("width") || "500px",
    title: modal.data("heading") || "",
    showCloseButton: true,
    showConfirmButton: false,

    onBeforeOpen: function(el) {
      $(that).trigger("modals.beforeOpen", el);
    },

    onOpen: makeClonedImageUploaderUnique,

    onClose: function(m) {
      if (window.iconPicker !== undefined)
        window.iconPicker.onModalClose();
    },
  }).then(
    function(confirm) { },
    function(dismiss) { }
  );

  function makeClonedImageUploaderUnique(modal) {
    $("a, button").blur();

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

$(document).on("ready turbolinks:load", function() {
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

$(document).on("click", ".submission-pieces__screenshot", function(e) {
  swal({
    imageUrl: $(e.target).data("modalUrl"),
  });
});

$(document).on("modals.beforeOpen",
  "[data-modal-fetch]",
  function(evt, modal) {
    $.ajax({
      method: "GET",
      headers: { "Content-Type": "text/html" },
      url: $(this).data("modalFetch"),
      success: function(html) {
        $(modal).find(".modal-content").html(html);
      },
    });
  }
);
