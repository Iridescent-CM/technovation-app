<template>
  <ul class="list--reset field_with_errors" v-if="errors">
    <li class="error" v-for="err in errors">
      {{ err }}
    </li>
  </ul>
</template>

<script>
  export default {
    props: ["errors"],
  };
</script>
