import mergeWith from 'lodash/mergeWith'

function mergeWithCustomizer(objValue, srcValue) {
  if (srcValue === false) {
    return 0
  } else if (srcValue === true) {
    return 1
  }
}

export default {
  setCancelButtonUrl (state, url) {
    state.cancelButtonUrl = url
  },

  setFormData (state, formData) {
    mergeWith(state.settings, formData, mergeWithCustomizer)
  },
}