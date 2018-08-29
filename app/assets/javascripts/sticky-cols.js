document.addEventListener('turbolinks:load', function () {
  $(".col--sticky").stick_in_parent({
    parent: ".col--sticky-parent",
    spacer: ".col--sticky-spacer",
    recalc_every: 1,
  })
})