$(document).on("click", "#team_submissions--menu a", function(e) {
  e.preventDefault();

  var anchor = $(this).attr('href'),
      offset = 92;

  $(anchor)[0].scrollIntoView();
  location.href = anchor;

  scrollBy(0, -offset);
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
