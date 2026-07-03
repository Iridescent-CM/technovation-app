<template>
  <button class="registration-btns" @click.prevent="$emit('next')">Next</button>
</template>

<script>
export default {
  name: "NextButton",
};
</script>
