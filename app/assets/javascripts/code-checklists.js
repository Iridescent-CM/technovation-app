$(document).on("ready turbolinks:load", function() {
  $(".indicator").each(function() {
    updateUIBasedOnPointsEarned({ indicator: $(this) });
  });
});

$(document).on("change", ".tc-form-group__item [type=checkbox]",
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
      pointsEach = parseInt($group.data("pointsEach")),
      totalPoints = $group.find(":checked").length * pointsEach;

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

  $group.find("[type=checkbox]").each(function() {
    var $explanation = $(this)
      .closest(".tc-form-group__item")
      .find(".explanation");

    if ($(this).prop("checked")) {
      $explanation.show();
    } else {
      $explanation.hide();
    }
  });
}
