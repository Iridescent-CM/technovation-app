/**
 * Sticky Navigation Directive
 *
 * Takes an expression which is an array of classes to apply when the element
 * becomes sticky.
 * For example: v-sticky-nav="['col-3', 'background-white']"
 * Will apply: class="sticky-nav col-3 background-white"
 */

let navIsSticky = false
let globalTopNavHeight = 0
let navBar = null
let containingElement = null
let classes = []

function setStickyNav () {
  if (containingElement && navBar) {
    const siblingContent = navBar.nextElementSibling
    const stickyPoint = parseInt(window.pageYOffset)
    const appOffset = parseInt(containingElement.offsetTop)

    navIsSticky = stickyPoint + globalTopNavHeight >= appOffset

    if (navIsSticky) {
      navBar.classList.add('sticky-nav')
      classes.forEach((currentClass) => {
        navBar.classList.add(currentClass)
      })
      navBar.style.marginTop = `${globalTopNavHeight}px`
      siblingContent.style.paddingTop = `${navBar.offsetHeight}px`
    } else {
      navBar.classList.remove('sticky-nav')
      classes.forEach((currentClass) => {
        navBar.classList.remove(currentClass)
      })
      navBar.style.marginTop = '0px'
      siblingContent.style.paddingTop = '0px'
    }
  }
}

export default {
  inserted: (el, binding, vnode) => {
    if (binding.value && binding.value.constructor === Array) {
      classes = binding.value
    }

    globalTopNavHeight = parseInt(document.querySelector('.header-container').offsetHeight)
    containingElement = vnode.context.$el
    navBar = el

    navBar.setAttribute('data-sticky-nav', true)

    window.addEventListener('scroll', setStickyNav)
  },

  unbind: (el, binding, vnode) => {
    window.removeEventListener('scroll', setStickyNav)
  },
}