let navIsSticky = false
let globalTopNavHeight = 0
let navBar = null
let containingElement = null

function setStickyNav () {
  if (containingElement && navBar) {
    const appOffset = containingElement.offsetTop

    navIsSticky = window.pageYOffset + globalTopNavHeight >= appOffset

    if (navIsSticky) {
      navBar.classList.add('sticky-nav')
      navBar.style.marginTop = `${globalTopNavHeight}px`
    } else {
      navBar.classList.remove('sticky-nav')
      navBar.style.marginTop = '0px'
    }
  }
}

export default {
  inserted: (el, binding, vnode) => {
    globalTopNavHeight = document.querySelector('.header-container').offsetHeight
    containingElement = vnode.context.$el
    navBar = el

    window.addEventListener('scroll', setStickyNav)
  },

  unbind: (el, binding, vnode) => {
    window.removeEventListener('scroll', setStickyNav)
  },
}