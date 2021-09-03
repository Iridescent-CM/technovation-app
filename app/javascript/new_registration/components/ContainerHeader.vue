<template>
  <div class="bg-energetic-blue">
    <h4 class="text-left font-extrabold p-4 text-white m-0"> {{ headerText }}</h4>
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