//= require application
//= require jquery.maskedinput

//= require forms
//= require search

document.addEventListener("turbolinks:load", function() {
  $("[data-keep-count-of]").each(function() {
    var $source = $($(this).data('keep-count-of')),
        $that = $(this);

    $source.on("input", function() {
      var numChars = $(this).val().length,
          counted = "character";

      $that.find('span:first-child').text(numChars);

      if (numChars !== 1)
        counted += "s";

      $that.find('span:last-child').text(counted);
    });
  });

  $("#background_check_candidate_ssn").mask("999-99-9999?");

  $(".show-hide").on("click", "a", function(e) {
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
});
