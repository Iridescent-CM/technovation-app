var defaultSubmissionDropzoneOptions = {
  maxFiles: 1,
  addRemoveLinks: true,
  dictDefaultMessage: "Drag and drop up a file here, " +
                      "<br />or <a class='button'>select a file</a>",
  method: "PUT",
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
  },

  init: function(el) {
    this.on("success", function(file, res) {
      $(".dropzone-save").fadeIn();
      $(".after-dropzone-save").hide();
    });
  },
}

Dropzone.options.teamSubmissionPitchPresentationDropzone = $.extend(
  {},
  defaultSubmissionDropzoneOptions,
  {
    paramName: "team_submission[pitch_presentation]",
    acceptedFiles: ".ppt,.pptx,.pdf",
  }
);

Dropzone.options.teamSubmissionBusinessPlanDropzone = $.extend(
  {},
  defaultSubmissionDropzoneOptions,
  {
    paramName: "team_submission[business_plan]",
    acceptedFiles: ".pdf",
  }
);

Dropzone.options.teamSubmissionSourcecodeDropzone = $.extend(
  {},
  defaultSubmissionDropzoneOptions,
  {
    method: "POST",
    paramName: "team_submission[source_code]",
    acceptedFiles: ".aia,.zip",
  }
);

Dropzone.autoDiscover = false;

$(document).on("ready DOMContentLoaded", Dropzone.discover);
