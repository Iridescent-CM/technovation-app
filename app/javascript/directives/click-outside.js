/**
 * Sticky Sidebar Directive
 *
 * Fires off an expression when element outside of component is clicked.
 * Example: v-click-outside="nameOfExpressionToCall"
 */

export default {
  bind (element, binding, vnode) {
    // Provided expression must evaluate to a function.
    if (typeof binding.value !== 'function') {
      const componentName = vnode.context.name

      let errorMessage = `[${binding.rawName}] provided expression ` +
        `'${binding.expression}', which is not a function. ` +
        'Please pass a valid function.'

      if (componentName) {
        errorMessage = `${errorMessage} Found in component '${componentName}'.`
      }

      console.error(errorMessage)
      return false
    }

    // Define handler and cache it on the element
    element.clickOutsideDirective = (event) => {
      if (!element.contains(event.target) && element !== event.target) {
        binding.value(event)
      }
    }

    // Add Event Listeners
    document.addEventListener('click', element.clickOutsideDirective)
  },
  unbind(element) {
    // Remove Event Listeners
    document.removeEventListener('click', element.vueDirectivesClickOutside)
    delete element.clickOutsideDirective
  },
}