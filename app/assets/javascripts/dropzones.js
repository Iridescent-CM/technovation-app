var defaultSubmissionDropzoneOptions = {
  maxFiles: 1,
  addRemoveLinks: true,
  dictDefaultMessage: "Drag and drop up a file here, " +
                      "<br />or <a class='button'>select a file</a>",
  method: "PUT",
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
  },

  init: function() {
    defaultInit(this);
  },
}

function defaultInit(el) {
  attachSuccess(el);
  attachRemovedFile(el);
}

function attachSuccess(el) {
  el.on("success", function(file, res) {
    $(".dropzone-save").fadeIn();
    $(".after-dropzone-save").hide();
    $(file).data({
      "remove-url": res.remove_url,
      "dom-id": res.dom_id,
    });

    $(file.previewElement).addClass("remove-with-" + res.dom_id);
  });

  el.on("addedfile", function(file) {
    $(file.previewElement).addClass(
      "remove-with-" + $(file).data("dom-id")
    );
  });
}

function attachRemovedFile(el) {
  el.on("removedfile", function(file) {
    $.ajax({
      url: $(file).data("remove-url"),
      method: "DELETE",
    });

    $("#" + $(file).data("dom-id")).fadeOut(function() {
      $(this).remove();
      $(".dz-started").removeClass("dz-started");
    });

    displayDzMessage();
  });
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

$(document).on("ready turbolinks:load", activateDropzones);

function activateDropzones() {
  updateScreenshots();
  Dropzone.discover();
}

function updateScreenshots() {
  var maxFiles = 6 - $("#sortable-list li").length;

  var screenshotDZ;

  Dropzone.options.teamSubmissionScreenshotsDropzone = $.extend(
    {},
    defaultSubmissionDropzoneOptions,
    {
      method: "POST",
      paramName: "team_submission[screenshots_attributes][][image]",
      maxFiles: maxFiles,
      acceptedFiles: ".jpg,.jpeg,.gif,.png",

      success: function(file) {
        var serverResp = JSON.parse(file.xhr.response),
            $li = $("<li>"),
            $img = $("<img>"),
            $removeDiv = $("<div>"),
            $removeIcon = $("<span>"),
            $removeLink = $("<a>", {
              'data-remove-on-delete': true,
              'data-remote': true,
              'data-method': "delete",
              'data-confirm': "Are you sure you want to " +
                              "delete the screenshot?",
            });

        $li.addClass("sortable-list__item remove-on-delete");
        $li.prop("id", serverResp.dom_id);
        $li.data("db-id", serverResp.image.id);

        $img.prop("src", serverResp.image.url);
        $img.prop("alt", serverResp.image.alt);
        $img.data("image-id", serverResp.image.id);
        $img.data("modal-url", serverResp.image.modal_url);
        $img.addClass("draggable submission-pieces__screenshot");
        $img.css({ width: "100%" });

        $removeDiv.addClass("sortable-list__item-actions");

        $removeIcon.addClass("icon-remove icon--red");

        $removeLink.prop("href", serverResp.remove_url);

        $removeLink.append($removeIcon);
        $removeDiv.append($removeLink);

        $li.append($img);
        $li.append($removeDiv);

        $("#sortable-list").append($li);
        displayDzMessage();
      },

      init: function() {
        screenshotDZ = this;
        defaultInit(this);

        $("#sortable-list li img").each(function() {
          var filename = $(this).prop("src").replace(/^.*[\\\/]/, '');

          var mockFile = {
            name: filename,
            size: $(this).data("file-size"),
          };

          $(mockFile).data("dom-id", $(this).data("dom-id"));

          screenshotDZ.emit("addedfile", mockFile);
          screenshotDZ.emit("complete", mockFile);
          screenshotDZ.emit(
            "thumbnail",
            mockFile,
            $(this).data("thumb-url")
          );
        });

        displayDzMessage();

        $(document).on(
          "removedfile",
          "#sortable-list",
          displayDzMessage
        );
      },
    }
  );

  function displayDzMessage() {
    var maxScreenshotsRemaining = 6 - $("#sortable-list li").length,
        html = "";

    screenshotDZ.options.maxFiles = maxScreenshotsRemaining;

    if (maxScreenshotsRemaining > 0) {
      var notOne = maxScreenshotsRemaining != 1,
          prefix = notOne ? "up to " : "",
          postfix = notOne ? "s" : "";

      screenshotDZ.enable();

      html = "Drag and drop ";
      html += prefix;
      html += maxScreenshotsRemaining;
      html += " screenshot" + postfix;
      html += " here, ";
      html += "<br />or ";
      html += "<a class='button small'>";
      html += "select ";
      html += prefix;
      html += maxScreenshotsRemaining;
      html += " screenshot";
      html += postfix;
      html += "</a>";
    } else {
      screenshotDZ.disable();
      html = "<p>";
      html += "Your team has uploaded the most screenshots allowed. ";
      html += "If you want to add more, you have to remove some first.";
      html += "</p>";
    }

    $(".dz-message span").html(html);
  }
}
