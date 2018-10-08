$(document).on("ready turbolinks:load", function() {
  $(".indicator").each(function() {
    updateUIBasedOnPointsEarned({ indicator: $(this) });
  });
});

function codeChecklistUIChangeHandler(event) {
  var $group = $(event.target).closest(".tc-form-group");
  var groupName = $group.data("groupName");
  var $indicator = $(".indicator[data-name='" + groupName + "']");
  var previousTotal = parseInt($indicator.find('.total').text());

  lockdownCheckboxesBasedOnTotal($group);

  updateUIBasedOnPointsEarned({ group: $group });

  var newTotal = parseInt($indicator.find('.total').text());

  if (previousTotal !== newTotal) {
    $indicator.addClass("notify");
    setTimeout(function() {
      $indicator.removeClass("notify");
    }, 200);
  }
}

var keyupTimeout = null;

$(document)
  .on("change", ".tc-form-group__item input, input.provide-preview", codeChecklistUIChangeHandler)
  .on("change", ".tc-form-group__item textarea", codeChecklistUIChangeHandler)
  .on("keyup", ".tc-form-group__item textarea", function(event) {
    clearTimeout(keyupTimeout);
    keyupTimeout = setTimeout(codeChecklistUIChangeHandler, 250, event);
  });

function lockdownCheckboxesBasedOnTotal($group) {
  var pointsPossible = parseInt($group.data('possible'), 10);
  var pointsEach = parseInt($group.data('points-each'), 10);
  var $checkboxes = $group.find('input[type="checkbox"]');

  var $checkedBoxes = $checkboxes.filter(function () {
    return $(this).prop('checked');
  });

  var $uncheckedBoxes = $checkboxes.filter(function () {
    return !$(this).prop('checked');
  });

  if ($checkedBoxes.length * pointsEach >= pointsPossible) {
    $uncheckedBoxes.prop('disabled', true);
  }
}

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
    toggleExplantationField(this);

    if (isCompletedCheckboxField(this)) {
      $(this).data("completed", true);
    } else if (isCompletedFileField(this)) {
      $(this).data("completed", true);
    } else if (isCompletedScreenshots(this)) {
      $(this).data("completed", true);
    } else {
      $(this).data("completed", false);
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
  } else {
    $completionCheck.hide();
  }

  function isCompletedFileField(field) {
    var isFileField = field.files != undefined;

    if (isFileField) {
      var uploadedFile = $(field).closest("div").find("img"),
          hasUploadedFile = !!uploadedFile.length,
          hasAttachedFile = !!field.files.length;

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
      return countNeeded <= countHas;
    } else {
      return false;
    }
  }

  function toggleExplantationField(field) {
    var $field = $(field);
    var $explanation = $field
      .closest(".tc-form-group__item")
      .find(".explanation");

    if ($field.prop("checked")) {
      $explanation.show();
    } else {
      $explanation.hide();
    }
  }

  function isCompletedCheckboxField(field) {
    var $checkbox = $(field);
    var $wrapper = $(field).closest('.tc-form-group__item');
    var $textarea = $wrapper.find('textarea');

    return Boolean(
      $checkbox.length &&
      $textarea.length &&
      $checkbox.prop('checked') &&
      $textarea.val()
    );
  }
}