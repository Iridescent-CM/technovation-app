document.addEventListener("turbolinks:load", function() {
  $("[data-keep-count-of]").each(function() {
    var $source = $($(this).data('keep-count-of')),
        $that = $(this),
        downFrom = $(this).data("down-from");

    showCharCount();

    $source.on("input", showCharCount);

    function showCharCount() {
      const numChars = $source.val().length;
      var counted = "character";

      if (downFrom) {
        const charsLeft = downFrom - numChars;

        $that.find('span:first-child').text(charsLeft);

        if (charsLeft <= 5) {
          $that.find('span:first-child').css({
            color: "firebrick",
          });
        } else if (charsLeft <= downFrom * 0.1) {
          $that.find('span:first-child').css({
            color: "orangered",
          });
        } else if (charsLeft <= downFrom * 0.3) {
          $that.find('span:first-child').css({
            color: "darkorange",
            fontWeight: "bold",
          });
        } else {
          $that.find('span:first-child').css({
            color: "inherit",
            fontWeight: "normal",
          });
        }

        if (charsLeft !== 1 && charsLeft !== -1)
          counted += "s";
      } else {
        $that.find('span:first-child').text(numChars);

        if (numChars !== 1 && numChars !== -1)
          counted += "s";
      }

      $that.find('span:last-child').text(counted);
    }
  });
});
