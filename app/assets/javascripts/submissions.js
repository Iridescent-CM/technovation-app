$(document).on("click", "#team_submissions__menu a", function (e) {
  e.preventDefault();

  var anchor = "#" + $(this).attr("href").split("#")[1],
    offset = 92;

  $(anchor)[0].scrollIntoView();
  location.href = anchor;

  scrollBy(0, -offset);
});

$(document).on("change", ".provide-preview", function (e) {
  var reader = new FileReader();

  reader.onload = function (e) {
    var $img = $("<img>");

    $img.prop("src", e.target.result).prop("width", 175);

    $(this).closest(".file-field").find(".img-preview").html($img);
  }.bind(this);

  reader.readAsDataURL($(this).prop("files")[0]);
});

document.addEventListener("turbo:load", function () {
  const usesOtherGadgetTypeCheckbox = document.getElementById(
    "team_submission_gadget_type_ids_4"
  );
  const usesGadgetsDescriptionDiv = document.getElementById(
    "uses_gadgets_description"
  );
  const usesGadgetsDescription = document.getElementById(
    "team_submission_uses_gadgets_description"
  );

  if (usesOtherGadgetTypeCheckbox) {
    if (usesOtherGadgetTypeCheckbox.checked) {
      usesGadgetsDescriptionDiv.style.display = "block";
    }

    usesOtherGadgetTypeCheckbox.addEventListener("change", function () {
      if (this.checked) {
        usesGadgetsDescriptionDiv.style.display = "block";
      } else {
        usesGadgetsDescriptionDiv.style.display = "none";
        usesGadgetsDescription.value = "";
      }
    });
  }
});
