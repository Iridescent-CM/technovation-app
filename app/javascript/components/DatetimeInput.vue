<template>
  <input
    ref="input"
    class="flatpickr"
    type="text"
    v-model="flatpickrValue"
  />
</template>

<script>
  import flatpickr from "flatpickr";

  export default {
    name: "flatpickr-input",

    data () {
      return {
        flatpickrValue: this.value,
      };
    },

    props: ["value", "options"],

    watch: {
      flatpickrValue () {
        this.$emit("input", this.flatpickrValue);
      },
    },

    mounted() {
      flatpickr(this.$refs.input, this.options);
    },
  }
</script>
