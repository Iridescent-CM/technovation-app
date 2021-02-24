ready('[data-keep-count-of]', function (element) {
  var $source = $($(element).data('keep-count-of')),
  $that = $(element),
  downFrom = $(element).data("down-from");

  showCharCount($source, $that, downFrom);

  $source.on("input", function() {
    showCharCount($source, $that, downFrom);
  });
});

ready('[data-word-count]', function (element) {
  $(".word-count__limit").text($(element).data("word-count-limit"));
  executeWordCounting($(element));
});

$(document).on("click", ".actions", function(e) {
  if ($(this).find("[disabled]").length > 0) {
    var $wordCountEl = $(this).find(".word-counter");

    $wordCountEl.addClass("notify");

    setTimeout(function() {
      $wordCountEl.removeClass("notify");
    }, 200);

    var $inputEl = $("[data-word-count]"),
        val = $inputEl.val();

    $inputEl
      .focus()
      .val("")
      .val(val)
      .scrollTop($inputEl[0].scrollHeight);
  }
});

$(document).on("input", "[data-word-count]", function(e) {
  executeWordCounting($(this));
});

function showCharCount($source, $that, downFrom) {
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

function executeWordCounting($el) {
  var wordCount = countWords($el);

  updateWordCounter($el, wordCount);

  function countWords($el) {
    return $el.val().split(" ").filter(function(word) {
      return word.length > 2;
    }).length;
  }

  function updateWordCounter($el, wordCount) {
    let wordCountDetailsContainer = $el.data().wordCountDetailsContainer;

    if (wordCountDetailsContainer) {
      var $total = $("#" + wordCountDetailsContainer + " .word-count__total");
    } else {
      var $total = $(".word-count__total");
    }

    $total
      .text(wordCount)
      .removeClass("word-count--plenty-remaining")
      .removeClass("word-count--some-remaining")
      .removeClass("word-count--none-remaining");

    var limit = $el.data("word-count-limit"),
        ratio = wordCount / parseFloat(limit);

    if (ratio >= 0.65 && ratio < 0.9) {
      $total.addClass("word-count--some-remaining");
    } else if (ratio >= 0.9) {
      $total.addClass("word-count--none-remaining");
    } else {
      $total.addClass("word-count--plenty-remaining");
    }

    updateSubmitButton(
      $el.closest("form").find("[type=submit]"),
      ratio
    );

    function updateSubmitButton(btn, ratio) {
      if (ratio > 1) {
        btn.prop("disabled", true);
      } else {
        btn.prop("disabled", false);
      }
    }
  }
}
