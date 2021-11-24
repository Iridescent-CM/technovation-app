<template>
  <label
    :class="[context.classes.label, 'input-label-text']"
    :for="context.id"
    v-html="label"
  />
</template>

<script>
export default {
  computed: {
    label() {
      const validationRules = this.context.rules.map(rule => rule.ruleName)

      if (validationRules.includes("required")) {
        return this.context.label + "<span class='formulate-required-field'>*</span>"
      } else {
        return this.context.label
      }
    }
  },
  props: {
    context: {
      type: Object,
      required: true
    }
  }
}
</script>
