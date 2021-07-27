(function () {
  function setStickyNav () {
    const header = document.querySelector('.header-container')

    // Make sure this isn't a sticky-kit header
    if (header !== null && !header.classList.contains('col--sticky')) {
      let headerHeight = parseInt(header.offsetHeight, 10)
      let spacer = document.querySelector('.header-container-spacer')

      if (!spacer) {
        spacer = document.createElement('div')
        spacer.classList.add('header-container-spacer')
        header.parentNode.insertBefore(spacer, header.nextSibling)
      }

      spacer.style.height = `${headerHeight}px`
    }
  }

  window.addEventListener('resize', setStickyNav)

  document.addEventListener('DOMContentLoaded', function () {
    setStickyNav()

    const header = document.querySelector('.header-container')

    if (header !== null) {
      // Create an observer instance linked to the callback function
      const observer = new MutationObserver(setStickyNav)

      // Start observing the header for configured mutations
      observer.observe(header, {
        attributes: true,
        childList: true,
        subtree: true
      });
    }
  });
})()
