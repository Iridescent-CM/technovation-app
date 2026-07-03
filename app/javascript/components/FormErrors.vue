<template>
  <ul v-if="errors" class="list--reset field_with_errors">
    <li v-for="(err, index) in errors" :key="index" class="error">
      {{ err }}
    </li>
  </ul>
</template>

<script>
export default {
  name: "FormErrors",
  props: {
    errors: {
      type: Array,
      default: null,
    },
  },
};
</script>
