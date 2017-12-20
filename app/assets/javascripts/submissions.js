$(document).on("click", "#team_submissions--menu a", function(e) {
  e.preventDefault();

  var anchor = $(this).attr('href'),
      offset = 92;

  $(anchor)[0].scrollIntoView();
  location.href = anchor;

  scrollBy(0, -offset);
});

$(document).on("ready turbolinks:load", function() {
  $.each($("[data-word-count]"), function() {
    $(".word-count__limit").text($(this).data("word-count-limit"));
    executeWordCounting($(this));
  });
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

$(document).on("input", "#team_submission_app_description", function(e) {
  executeWordCounting($(this));
});

function executeWordCounting($el) {
  var wordCount = countWords($el);

  updateWordCounter($el, wordCount);

  function countWords($el) {
    return $el.val().split(" ").filter(function(word) {
      return word.length > 2;
    }).length;
  }

  function updateWordCounter($el, wordCount) {
    var $total = $(".word-count__total");

    $total
      .text(wordCount)
      .removeClass("word-count--plenty-remaining");

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

var defaultSubmissionDropzoneOptions = {
  maxFiles: 1,
  dictDefaultMessage: "Drop file here to upload, " +
                      "or click to select a file",
  method: "PUT",
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
  },

  init: function() {
    this.on("success", function(file) {
      $(".dropzone-save").fadeIn();
      $(".after-dropzone-save").hide();
    });
  },
}

Dropzone.options.teamSubmissionBusinessPlanDropzone = $.extend(
  {},
  defaultSubmissionDropzoneOptions,
  {
    paramName: "team_submission[business_plan_attributes][uploaded_file]",
    acceptedFiles: ".doc,.docx,.pdf",
  }
);

Dropzone.options.teamSubmissionSourcecodeDropzone = $.extend(
  {},
  defaultSubmissionDropzoneOptions,
  {
    paramName: "team_submission[source_code]",
    acceptedFiles: ".aia,.zip",
  }
);

Dropzone.options.teamSubmissionScreenshotsDropzone = $.extend(
  {},
  defaultSubmissionDropzoneOptions,
  {
    paramName: "team_submission[screenshots_attributes][][image]",
    dictDefaultMessage: "Drop up to 6 screenshot files here, " +
                        "or click to select up to 6 files",
    maxFiles: 6,
    acceptedFiles: ".jpg,.jpeg,.gif,.png",
  }
);

Dropzone.autoDiscover = false;

$(document).on("ready turbolinks:load", Dropzone.discover);
