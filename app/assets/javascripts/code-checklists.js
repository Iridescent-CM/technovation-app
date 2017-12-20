$(document).on("ready turbolinks:load", function() {
  $(".indicator").each(function() {
    updateUIBasedOnPointsEarned({ indicator: $(this) });
  });
});

$(document).on("change", ".tc-form-group__item input",
  function(){
    var $group = $(this).closest(".tc-form-group");
    updateUIBasedOnPointsEarned({ group: $group });

    var groupName = $group.data("groupName"),
        $indicator = $(".indicator[data-name='" + groupName + "']");

    $indicator.addClass("notify");
    setTimeout(function() {
      $indicator.removeClass("notify");
    }, 200);
  }
);

function updateUIBasedOnPointsEarned(opts) {
  var $indicator = opts.indicator,
      $group = opts.group;

  if ($indicator) {
    var groupName = $indicator.data("name");
    $group = $(".tc-form-group[data-group-name='" + groupName + "']");
  } else {
    var groupName = $group.data("groupName");
    $indicator = $(".indicator[data-name='" + groupName + "']");
  }

  var $completionCheck = $indicator.find(".icon-check-circle"),
      $possible = $indicator.find(".possible"),
      $total = $indicator.find(".total"),

      pointsPossible = parseInt($group.data("possible")),
      pointsEach = parseInt($group.data("pointsEach"));

  $group.find("input").each(function() {
    var $explanation = $(this)
      .closest(".tc-form-group__item")
      .find(".explanation");

    if ($(this).prop("checked")) {
      $(this).data("completed", true);
      $explanation.show();
    } else if (isCompletedFileField(this)) {
      $(this).data("completed", true);
    } else if (isCompletedScreenshots(this)) {
      $(this).data("completed", true);
    } else {
      $(this).data("completed", false);
      $explanation.hide();
    }
  });

  var totalPoints = $group.find("input").filter(function(idx, item) {
    return $(item).data("completed");
  }).length * pointsEach;

  if ($group.data("allRequired") && totalPoints != pointsPossible) {
    totalPoints = 0;
  }

  $possible.text(pointsPossible);
  $total.text(totalPoints);

  if (totalPoints === pointsPossible) {
    $completionCheck.show();

    $group
      .find("[type=checkbox]")
      .not(":checked")
      .prop("disabled", true);
  } else {
    $completionCheck.hide();

    $group
      .find("[type=checkbox]")
      .prop("disabled", false);
  }

  function isCompletedFileField(field) {
    var isFileField = field.files != undefined;

    if (isFileField) {
      var uploadedFile = $(field).closest("div").find("img"),
          hasUploadedFile = uploadedFile.length > 0,
          hasAttachedFile = field.files.length > 0;

      return hasUploadedFile || hasAttachedFile;
    } else {
      return false;
    }
  }

  function isCompletedScreenshots(field) {
    var isScreenshots = field.type === "hidden" &&
      $(field).data("countNeeded");

    if (isScreenshots) {
      var countNeeded = parseInt($(field).data("countNeeded")),
          countHas = parseInt($(field).data("countHas"));
      return countNeeded === countHas;
    } else {
      return false;
    }
  }
}
