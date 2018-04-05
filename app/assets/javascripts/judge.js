//= require application
//= require toggling-select

$(document).on("click", ".screenshot-nav__item", evt => {
  let goToIdx

  if (evt.target.nodeName === "IMG") {
    goToIdx = $(evt.target.parentElement).data('goTo')
  } else {
    goToIdx = $(evt.target).data('goTo')
  }

  const goToEl = $('[data-modal-idx=' + goToIdx + ']')
  swal.close()
  goToEl.trigger('click')
})