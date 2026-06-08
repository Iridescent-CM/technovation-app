<template>
  <button
    @click.prevent="$emit('next')"
    class="registration-btns"
    :disabled="disabled"
  >
    Next
  </button>
</template>

<script>
export default {
  name: "NextButton",
  props: {
    disabled: {
      type: Boolean,
      default: false,
    },
  },
};
</script>
