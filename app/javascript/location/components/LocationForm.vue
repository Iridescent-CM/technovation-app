<template>
  <div>
    <label for="location_city">City</label>

    <input
      type="text"
      id="location_city"
      v-model="city"
    />

    <label for="location_state">State / Province</label>

    <input
      type="text"
      id="location_state"
      v-model="stateCode"
    />

    <label for="location_country">Country / Territory</label>

    <select
      id="location_country"
      v-model="countryCode"
    >
      <option
        v-for="country in countries"
        :key="country[1]"
        :value="country[1]"
      >
        {{ country[0] }}
      </option>
    </select>
  </div>
</template>

<script>
export default {
  data () {
    return {
      city: "",
      stateCode: "",
      countryCode: "",
    }
  },

  props: {
    scopeName: {
      type: String,
      required: true,
    },

    countries: {
      type: Array,
      required: true,
    },
  },

  created () {
    window.axios.get(this.getCurrentLocationEndpoint).then(({ data }) => {
      this.city = data.city
      this.stateCode = data.state_code
      this.countryCode = data.country_code
    })
  },

  updated () {
    this.initChosen()
  },

  computed: {
    getCurrentLocationEndpoint () {
      return `/${this.scopeName}/current_location`
    },
  },

  methods: {
    initChosen () {
      const $country = $("#location_country")

      $country.chosen({
        allow_single_deselect: true,
      })

      $country.val(this.countryCode)
      $country.trigger("chosen:updated")
    },
  },
}
</script>

<style lang="scss" scoped>
</style>