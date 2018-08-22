/**
 * Sticky Sidebar Directive
 *
 * Takes an expression which is an array of classes to apply when the element
 * becomes sticky.
 * For example: v-sticky-sidebar="['col-3', 'background-white']"
 * Will apply: class="sticky-nav col-3 background-white"
 */

let navIsSticky = false
let globalTopNavHeight = 0
let sidebar = null
let containingElement = null
let classes = []
let additionalOffset = 0

function setStickyNav () {
  if (containingElement && sidebar) {
    const stickyPoint = parseInt(window.pageYOffset, 10)
    const appOffset = parseInt(sidebar.parentElement.getBoundingClientRect().top, 10)

    navIsSticky = stickyPoint >= (appOffset + globalTopNavHeight) - additionalOffset

    if (navIsSticky) {
      sidebar.classList.add('sticky-sidebar')
      classes.forEach((currentClass) => {
        sidebar.classList.add(currentClass)
      })
      sidebar.style.marginTop = `${globalTopNavHeight + additionalOffset}px`
    } else {
      sidebar.classList.remove('sticky-sidebar')
      classes.forEach((currentClass) => {
        sidebar.classList.remove(currentClass)
      })
      sidebar.style.marginTop = '0px'
    }
  }
}

export default {
  inserted: (el, binding, vnode) => {
    if (binding.value && binding.value.constructor === Array) {
      classes = binding.value
    }

    globalTopNavHeight = parseInt(document.querySelector('.header-container').offsetHeight, 10)
    containingElement = vnode.context.$el
    sidebar = el

    const stickyNavItems = document.querySelectorAll('[data-sticky-nav]')
    for (let i = 0; i < stickyNavItems.length; i += 1) {
      additionalOffset = parseInt(stickyNavItems[0].offsetHeight, 10)
    }

    sidebar.setAttribute('data-sticky-sidebar', true)

    window.addEventListener('scroll', setStickyNav)
  },

  unbind: (el, binding, vnode) => {
    window.removeEventListener('scroll', setStickyNav)
  },
}