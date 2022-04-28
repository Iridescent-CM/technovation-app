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

    const $form = $(modal).find(".new_image_direct_uploader");

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

$(document).on("click", ".img-modal", function(e) {
  var html, animation

  if (typeof $(e.target).data("modalIdx") !== 'undefined') {
    const last = parseInt($("#screenshots-nav").data("modalLast"))
    const idx = parseInt($(e.target).data("modalIdx"))
    const nextIdx = idx + 1 > last ? 0 : idx + 1
    const prevIdx = idx - 1 < 0 ? last : idx - 1

    html = "<div class='flex justify-between screenshot-nav'>"

    html += "<div class='" +
            "screenshot-nav__item grid__col-auto grid--justify-center" +
            "' data-go-to='" + prevIdx + "'>"
    html += "<img src='https://icongr.am/fontawesome/angle-left.svg' />"
    html += "</div>"

    html += "<div>"
    html += "<img class='screenshot__img' " +
            "src='" + $(e.target).data("modalUrl") + "' />"
    html += "</div>"

    html += "<div class='" +
            "screenshot-nav__item grid__col-auto grid--justify-center" +
            "' data-go-to='" + nextIdx + "'>"
    html += "<img src='https://icongr.am/fontawesome/angle-right.svg' />"
    html += "</div>"

    html += "</div>"
    animation = false
  } else {
    html = "<img " +
      "src='" + $(e.target).data("modalUrl") + "' " +
      "width='100%' />"
    animation = true
  }

  swal({
    html: html,
    confirmButtonText: "Done",
    animation: animation,
    customClass: 'user-select--none',
    width: $(e.target).data("width") || "32rem",
  });
});

$(document).on("modals.beforeOpen",
  "[data-modal-fetch]",
  function(evt, modal) {
    $.ajax({
      method: "GET",
      headers: { "Content-Type": "text/html" },
      url: $(this).data("modalFetch"),
      dataType: 'html',
      success: function(html) {
        $(modal).find(".modal-content").html(html);
      },
    });
  }
);
