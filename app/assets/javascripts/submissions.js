$(document).on("click", "#team_submissions--menu a", function(e) {
  e.preventDefault();

  var anchor = $(this).attr('href'),
      offset = 92;

  $(anchor)[0].scrollIntoView();
  location.href = anchor;

  scrollBy(0, -offset);
});

$(document).on("ready turbolinks:load", function() {
  var $wordCounters = $("[data-word-count]");
  $.each($wordCounters, function() {
    var limit = $(this).data("word-count-limit");
    $(this).find(".word-count__limit").text(limit);
  });
});

$(document).on("click", ".actions", function(e) {
  if ($(this).find("[disabled]").length > 0) {
    var $wordCountEl = $(this).find("[data-word-count]");

    $wordCountEl.addClass("notify");

    setTimeout(function() {
      $wordCountEl.removeClass("notify");
    }, 200);

    var $inputEl = $($wordCountEl.data("word-count")),
        val = $inputEl.val();

    $inputEl
      .focus()
      .val("")
      .val(val)
      .scrollTop($inputEl[0].scrollHeight);
  }
});

$(document).on("input", "#team_submission_app_description", function(e) {
  var $wordCounter = $('[data-word-count="#' + e.target.id + '"]'),
      limit = $wordCounter.data("word-count-limit"),
      wordCount = $(this).val().split(" ").filter(function(word) {
        return word.length > 2;
      }).length,
      ratio = wordCount / parseFloat(limit),
      $total = $wordCounter.find(".word-count__total");

  $total.text(wordCount).removeClass("word-count--plenty-remaining");

  if (ratio >= 0.65 && ratio < 0.9) {
    $total.addClass("word-count--some-remaining");
  } else if (ratio >= 0.9) {
    $total.addClass("word-count--none-remaining");
  } else {
    $total.addClass("word-count--plenty-remaining");
  }

  var $submitBtn = $(this).closest("form").find("[type=submit]");

  if (ratio > 1) {
    $submitBtn.prop("disabled", true);
  } else {
    $submitBtn.prop("disabled", false);
  }
});

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
  }
);

Dropzone.options.teamSubmissionSourcecodeDropzone = $.extend(
  {},
  defaultSubmissionDropzoneOptions,
  {
    paramName: "team_submission[source_code]",
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
  }
);

Dropzone.autoDiscover = false;

$(document).on("ready turbolinks:load", Dropzone.discover);
