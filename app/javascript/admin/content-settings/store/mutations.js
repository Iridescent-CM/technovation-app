import mergeWith from "lodash/mergeWith";

function mergeWithCustomizer(objValue, srcValue) {
  if (srcValue === false) {
    return 0;
  } else if (srcValue === true) {
    return 1;
  }
}

export default {
  setFormData(state, formData) {
    mergeWith(state, formData, mergeWithCustomizer);
  },
  setIsSuperAdmin(state, isSuperAdmin) {
    state.is_super_admin = JSON.parse(isSuperAdmin);
  },
};
