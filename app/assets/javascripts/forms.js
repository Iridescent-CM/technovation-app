// Assumes a remote enabled form
$(document).on("change", "[data-submit-on-change] input", function() {
  $(this).submit();
});

$(document).on("ajax:beforeSend", "form[data-remote]", function() {
  $(this).find('.field_with_errors')
    .removeClass("field_with_errors")
    .find(".error")
    .remove();
})

$(document).on(
  "ajax:error",
  "form[data-remote]",
  function(event, xhr, status, error) {
    const $form = $(this);

    $.each(xhr.responseJSON, function(k, v) {
      var $err = $("<span>");
      $err.addClass("error");
      $err.text(v);

      const $input = $form.find("input[name*='" + k + "']"),
            $wrapper = $input.closest('p');

      if ($wrapper.length > 0) {
        $wrapper.addClass('field_with_errors').append($err);
      } else {
        var $fullErrWrapper = $("<div>"),
            $fullErr = $("<span>");

        $fullErrWrapper.addClass("field_with_errors");
        $fullErr.addClass("error");

        $fullErr.text(k + " " + v);
        $fullErrWrapper.html($fullErr);

        $input.after($fullErrWrapper);
      }
    });
  }
);

$(document).on("ajax:beforeSend", "form[data-wait-for-jobs]", function() {
  $(this).addClass("waiting")
    .css({ height: 0 });
}).on("ajax:success", "form[data-wait-for-jobs]", function(e, res) {
  var checkJobStatus,
      $form = $(this);

  checkJobStatus = function(url) {
    $.ajax({
      method: "GET",
      url: url,
      success: function(json) {
        if (json.status !== "complete") {
          setTimeout(checkJobStatus(url), 1000);
        } else {
          var $link = $("<a>");

          $link.prop("href", json.download_url);
          $link.addClass("button");
          $link.text("Download now");
          $link.on("click", function() { swal.close(); });

          $form.removeClass("waiting")
            .addClass("complete")
            .after($link)
            .remove();
        }
      }
    });
  }

  checkJobStatus(JSON.parse(res).status_url);
});
