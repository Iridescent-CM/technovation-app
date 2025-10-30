$(document).on("turbo:load", function () {
  const anchor = $(location).attr("hash");

  $("#tab-wrapper div.tw-tab-content>a").click(function (e) {
    e.preventDefault();

    let heading = $(this).data("heading");
    if (heading !== undefined) {
      $("#energetic-heading").html(heading);
    }

    let tabid = $(this).attr("href");

    $("#tab-wrapper div a, .tab div").removeClass("tw-active active-tab");

    $(".tab-content").hide();
    $(tabid).show();
    $(this).addClass("tw-active active-tab");
  });

  if (anchor.length > 0 && anchor === "#parent-tab-content") {
    $(`a[href*='#parent-tab-content']`).click();
  }

  const checkParentalConsentStatusLink = document.getElementById(
    "check-parental-consent-status"
  );

  if (checkParentalConsentStatusLink) {
    checkParentalConsentStatusLink.addEventListener("click", (e) => {
      e.preventDefault();

      document.getElementById("parental-tab").click();
    });
  }
});
