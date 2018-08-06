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

    computed: {
      srcUrl () {
        return `https://icongr.am/fontawesome/${this.name}.svg` +
               `?color=${this.color}&size=${this.size}`
      },
    }
  }
</script>
