<template>
  <input ref="input" v-model="flatpickrValue" class="flatpickr" type="text" />
</template>

<script>
import flatpickr from "flatpickr";

export default {
  name: "FlatpickrInput",

  props: {
    value: {
      type: String,
      default: "",
    },

    options: {
      type: Object,
      default() {
        return {};
      },
    },
  },

  data() {
    return {
      flatpickrValue: this.value,
    };
  },

  watch: {
    value(newValue) {
      this.flatpickrValue = newValue;
    },

    flatpickrValue() {
      this.$emit("input", this.flatpickrValue);
    },
  },

  mounted() {
    flatpickr(this.$refs.input, this.options);
  },
};
</script>
