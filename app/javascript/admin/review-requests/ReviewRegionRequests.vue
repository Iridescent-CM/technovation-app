<template>
  <div v-if="isLoading" class="loading">
    Loading...
  </div>

  <div v-else-if="hasError" class="error">
    Error.
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data () {
    return {
      isLoading: true,
      hasError: false,
      requests: [],
    }
  },

  props: ['sourceUrl'],

  created () {
    this.loadData()
  },

  methods: {
    loadData () {
      axios.get(this.sourceUrl).then(({ data }) => {
        data.data.forEach((request) => {
          this.requests.push(request)
        })

        this.isLoading = false
      }).catch((err) => {
        console.error(err)
        this.isLoading = false
        this.hasError = true
      })
    },
  },
}
</script>

<style scoped>
</style>