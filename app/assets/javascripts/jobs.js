//= require cable

var watchJobs;

watchJobs = function() {
  const $meta = $("[data-current-profile-id]"),
        profileId = $meta.data("currentProfileId"),
        profileType = $meta.data("currentProfileType");

  window.App.cable.subscriptions.create(
    {
      channel: "JobChannel",
      current_profile_id: profileId,
      current_profile_type: profileType,
    },
    {
      received: function(data) {
        console.log("JOB CHANNEL RECEIVED", data);

        const $jobsToast = $("#queued-jobs"),
              $whenReady = $jobsToast.find(".when-ready");

        $jobsToast.removeClass("ready");
        $whenReady.html("");

        if (data.status === "complete") {
          $whenReady.html("<p>Your file is ready!</p>")

          var $cancelWrap = $("<p>"),
              $cancel = $("<a>"),
              $link = $("<a>");

          $link.appendTo($whenReady);
          $cancelWrap.appendTo($whenReady);
          $cancel.appendTo($cancelWrap);

          $link.prop("href", data.url);
          $link.attr("data-update-url", data.update_url);
          $link.addClass("button small");
          $link.text("Download " + data.filename);

          $cancel.prop("href", "#");
          $cancel.attr("data-update-url", data.update_url);
          $cancel.attr("data-prevent-default", true);
          $cancel.addClass("danger");
          $cancel.text("I no longer need this file");

          $jobsToast
            .removeClass("waiting")
            .addClass("ready");
        } else {
          $jobsToast.removeClass("ready").addClass("waiting");
          $whenReady.html("");
        }
      },
    }
  );
}

$(document).on("ready DOMContentLoaded", watchJobs);

$(document).on("click", "#queued-jobs a", function(e) {
  if ($(this).data("preventDefault"))
    e.preventDefault();

  $.ajax({
    method: "PATCH",
    url: $(this).data("updateUrl"),
    success: function() {
      $("#queued-jobs").removeClass("ready waiting")
        .find(".when-ready")
        .html("");
    },
  });
});
