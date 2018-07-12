$(document).on('click', '.flash .icon-close', function() {
  $(this).closest('.flash').fadeOut('easeout', function() {
    $("#flash").removeClass("fixed");
    $(this).remove();
  });
});

document.addEventListener("turbolinks:load", function() {
  $(document).ajaxComplete(function(_, xhr) {
    if (xhr.status === 200) {
      var res = false

      try {
        res = JSON.parse(xhr.responseText)
      } catch (err) {
        return false
      }

      if (!!res) {
        const $flash = $("<div>"),
              $flashText = $("<span>"),
              $flashClose = $("<span>")

        if (res.flash) {
          $flash.addClass("flash flash--success")
          $flashClose.addClass("icon-close")
          $flashText.text(res.flash.success)

          $flash.append($flashText)
          $flash.append($flashClose)

          $flash.hide()
          $("#flash").addClass("fixed").html($flash)
          $flash.fadeIn()
        }
      }
    }
  });
});
