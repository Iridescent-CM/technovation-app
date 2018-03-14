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
    data () {
      return {
        srcUrl: "https://icongr.am/fontawesome/" + this.name + ".svg" +
                "?color=" + this.color +
                "&size=" + this.size,
      };
    },

    props: {
      alt: String,
      title: String,
      className: String,
      name: String,
      color: String,
      size: [String, Number],

      handleClick: {
        type: Function,
        required: false,
        default: () => { return false; },
      },
    },
  }
</script>
