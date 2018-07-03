<template>
  <div v-if="isLoading" class="loading">
    Loading...
  </div>
</template>

<script>
export default {
  data () {
    return {
      isLoading: true,
    }
  },

  methods: {
    loadData () {
      this.isLoading = false
    },
  },
}
</script>

<style scoped>
</style>