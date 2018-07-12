<template>
  <div>
    <input type="text" id="location_city" />
    <input type="text" id="location_state" />
    <select id="location_country"></select>
  </div>
</template>

<script>
export default {
  data () {
    return {
      city: "",
      state_code: "",
      country_code: "",
    }
  },

  props: ['scopeName'],

  computed: {
    getCurrentLocationEndpoint () {
      return `/${this.scopeName}/current_location`
    },
  },

  created() {
    window.axios.get(this.getCurrentLocationEndpoint).then(({ data }) => {
      this.city = data.city
      this.state_code = data.state_code
      this.country_code = data.country_code
    })
  },
}
</script>

<style lang="scss" scoped>
</style>