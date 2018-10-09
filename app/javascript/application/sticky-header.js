(function () {
  function setStickyNav () {
    const header = document.querySelector('.header-container')

    // Make sure this isn't a sticky-kit header
    if (header !== null && !header.classList.contains('col--sticky')) {
      const content = document.querySelector('.main-container')
      const headerHeight = parseInt(header.offsetHeight, 10)

      content.style.paddingTop = `${headerHeight}px`
    }
  }

  window.addEventListener('resize', setStickyNav)

  document.addEventListener('turbolinks:load', function () {
    setStickyNav()
  });
})()