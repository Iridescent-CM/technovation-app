$(document).on("turbo:load", function () {
  const anchor = $(location).attr("hash");
  const TAB_ANCHOR = /^#[\w-]+$/;

  $("#tab-wrapper div.tw-tab-content>a").click(function (e) {
    // Tab links may point at another page, so use only the fragment as the
    // selector and let the browser navigate when the tab isn't on this page.
    const tabid = this.hash;

    if (!TAB_ANCHOR.test(tabid) || $(tabid).length === 0) {
      return;
    }

    e.preventDefault();

    let heading = $(this).data("heading");
    if (heading !== undefined) {
      $("#energetic-heading").html(heading);
    }

    $("#tab-wrapper div a, .tab div").removeClass("tw-active active-tab");

    $(".tab-content").hide();
    $(tabid).show();
    $(this).addClass("tw-active active-tab");
  });

  if (TAB_ANCHOR.test(anchor) && $(anchor).length > 0) {
    $(`#tab-wrapper div.tw-tab-content>a[href$='${anchor}']`).first().click();
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
