<template>
  <img :src="srcUrl" />
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

    props: ["name", "color", "size"],
  }
</script>
