document.addEventListener("turbo:load", function() {
  $(".chosen, select.enum_filter").chosen({
    allow_single_deselect: true,
  });

  $(".chosen").not(".dob_field")
    .next('.chosen-container')
    .prop('style', 'width: 100%');

  $(".dob_field").next('.chosen-container')
    .prop('style', 'width: 30%');

  // Chosen.js triggers jQuery change events (not native DOM events), so
  // Stimulus controllers using addEventListener("change") never fire.
  // Bridge: re-dispatch a native change event so framework-free code can listen.
  $(".dob_field").on("change", function() {
    this.dispatchEvent(new Event("change", { bubbles: true }));
  });
});
