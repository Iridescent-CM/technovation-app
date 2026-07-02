<template>
  <input
    v-model="numericValue"
    type="text"
    :name="inputName"
    @keydown="restrictValue"
  />
</template>

<script>
export default {
  props: {
    inputName: {
      type: String,
      default: "",
    },

    value: {
      type: Number,
      default: 0,
    },

    minimum: {
      type: Number,
      default: 0,
    },

    maximum: Number,
  },

  data() {
    return {
      numericValue: 0,
    };
  },

  watch: {
    numericValue(newValue) {
      this.recalculateValue(newValue);
    },

    value: {
      immediate: true,
      handler(newValue) {
        this.numericValue = newValue;
      },
    },
  },

  methods: {
    recalculateValue(value) {
      const integerValue = parseInt(value, 10);

      if (isNaN(integerValue)) {
        return;
      }

      if (Boolean(this.maximum) && integerValue >= this.maximum) {
        this.numericValue = this.maximum;
      } else if (integerValue <= this.minimum) {
        this.numericValue = this.minimum;
      } else {
        this.numericValue = integerValue;
      }

      this.$emit("input", this.numericValue);
    },

    restrictValue(event) {
      if (!this.isValidKey(event.key)) {
        event.preventDefault();
        return false;
      }

      return true;
    },

    isValidKey(key) {
      const validKeys = [
        "Backspace",
        "Delete",
        "Enter",
        "Tab",
        "ArrowUp",
        "ArrowDown",
        "ArrowLeft",
        "ArrowRight",
      ];

      const numericRegex = /^\d+$/;

      return numericRegex.test(key) || validKeys.includes(key);
    },
  },
};
</script>
