<template>
  <img
    :class="className"
    :alt="alt"
    :title="title"
    :src="srcUrl"
    @click="handleClick"
  />
</template>

<script>
export default {
  name: "AppIcon",
  props: {
    alt: {
      type: String,
      default: "",
    },

    title: {
      type: String,
      default: "",
    },

    className: {
      type: String,
      default: "",
    },

    name: {
      type: String,
      default: "",
    },

    color: {
      type: String,
      default: "",
    },

    size: {
      type: [String, Number],
      default: "",
    },

    handleClick: {
      type: Function,
      required: false,
      default: () => {
        return false;
      },
    },
  },

  computed: {
    srcUrl() {
      return (
        `https://icongr.am/fontawesome/${this.name}.svg` +
        `?color=${this.color}&size=${this.size}`
      );
    },
  },
};
</script>
