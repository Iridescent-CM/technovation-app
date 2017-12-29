var defaultSubmissionDropzoneOptions = {
  maxFiles: 1,
  dictDefaultMessage: "Drag and drop up a file here, " +
                      "<br />or <a class='button'>select a file</a>",
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

Dropzone.autoDiscover = false;

$(document).on("ready turbolinks:load", function() {
  var maxScreenshotsRemaining = $("#screenshots")
    .data("maxFilesRemaining"),
    notOne = parseInt(maxScreenshotsRemaining) != 1,
    prefix = notOne ? "up to " : "",
    postfix = notOne ? "s" : "";

  Dropzone.options.teamSubmissionScreenshotsDropzone = $.extend(
    {},
    defaultSubmissionDropzoneOptions,
    {
      paramName: "team_submission[screenshots_attributes][][image]",
      dictDefaultMessage: "Drag and drop " +
                          prefix +
                          maxScreenshotsRemaining +
                          " screenshot" + postfix +
                          " here, " +
                          "<br />or " +
                          "<a class='button small'>select " +
                          prefix +
                          maxScreenshotsRemaining +
                          " screenshot" + postfix +
                          "</a>",
      maxFiles: parseInt(maxScreenshotsRemaining),
      acceptedFiles: ".jpg,.jpeg,.gif,.png",
    }
  );

  Dropzone.discover();
});
