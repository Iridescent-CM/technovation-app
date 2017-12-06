//= require application
//= require dropzone

//= require forms
//= require search

var offset = 92;

$(document).on("click", "#team_submissions--menu a", function(e) {
  e.preventDefault();
  var anchor = $(this).attr('href');
  $(anchor)[0].scrollIntoView();
  location.href = anchor;
  scrollBy(0, -offset);
});

var defaultDropzoneOptions = {
  maxFiles: 1,
  dictDefaultMessage: "Drop file here to upload, or click to select a file",

  init: function() {
    this.on("success", function(file) {
      $(".dropzone-save").fadeIn();
      $(".after-dropzone-save").hide();
    });
  },
}

Dropzone.options.teamSubmissionBusinessPlanDropzone = $.extend({}, defaultDropzoneOptions, {
  paramName: "team_submission[business_plan_attributes][uploaded_file]",
});

Dropzone.options.teamSubmissionSourcecodeDropzone = $.extend({}, defaultDropzoneOptions, {
  paramName: "team_submission[source_code]",
});

Dropzone.autoDiscover = false;

$(document).on("ready turbolinks:load", Dropzone.discover);
