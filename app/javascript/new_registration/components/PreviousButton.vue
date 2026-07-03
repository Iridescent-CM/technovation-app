<template>
  <button class="registration-btns" @click.prevent="$emit('prev')">Back</button>
</template>

<script>
export default {
  name: "PreviousButton",
};
</script>
