<template>
  <div class="energetic-blue">
    <h4 class="text-left font-extrabold p-4 text-white"> {{ headerText }}</h4>
  </div>
</template>

<script>
export default {
  name: "ContainerHeader",
  props: {
    headerText: String
  }
}
</script>

<style scoped>

</style>