document.addEventListener('turbolinks:load', () => {
  $(".col--sticky").stick_in_parent({
    parent: ".col--sticky-parent",
    spacer: ".col--sticky-spacer",
    recalc_every: 1,
  })
})