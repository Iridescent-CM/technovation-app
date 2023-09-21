//= require application
//= require jquery.maskedinput
//= require jquery-ui/widgets/accordion
//= require dropzone

//= require forms
//= require search
//= require char-counter
//= require toggling-select
//= require submissions
//= require dropzones

document.addEventListener("turbolinks:load", function () {
  $("#bg-check-invite-btn").on("click", function (e) {
    $(this).addClass("button--disabled");
    $("#overlay").fadeIn(300);
    $("#spinner-text").text("Processing your request...");
  });

  $("#background_check_candidate_ssn").mask("999-99-9999?");

  $(".show-hide").on("click", "a", function (e) {
    e.preventDefault();
    const state = $(this).data("state"),
      $that = $(e.target),
      $fieldToObfuscate = $that.closest(".show-hide").find("input");

    if (state === "showing") {
      $that.text("Show");
      $that.data("state", "hidden");
      $fieldToObfuscate.prop("type", "password");
    } else {
      $that.text("Hide");
      $that.data("state", "showing");
      $fieldToObfuscate.prop("type", "text");
    }
  });

  $(".accordion").accordion();
});
