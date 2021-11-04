<template>
  <button @click.prevent="$emit('next')" class="registration-btns">Next</button>
</template>

<script>
export default {
  name: "NextButton"
}
</script>