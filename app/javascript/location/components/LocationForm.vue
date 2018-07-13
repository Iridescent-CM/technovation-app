<template>
  <form
    class="panel panel--contains-bottom-bar panel--contains-top-bar"
    @submit.prevent="handleSubmit"
  >
    <div class="panel__top-bar">
      Confirm the location that we have on file for {{ subject }}
    </div>

    <div class="panel__content">
      <label for="location_city">City</label>

      <input
        type="text"
        id="location_city"
        ref="cityField"
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
      &nbsp;
      <a
        href="#"
        class="color--danger font-size--small"
        @click.prevent="resetForm"
      >
        reset this form
      </a>

      <ul v-if="suggestions.length">
        <li
          v-for="suggestion in suggestions"
          :key="suggestion.city"
         >
          {{ suggestion.city }} - {{ suggestion.stateCode }} - {{ suggestion.countryCode }}
        </li>
      </ul>
    </div>

    <div class="panel__bottom-bar">
      <p class="padding--none margin--none">
        <a
          href="javascript:history.back();"
          class="color--secondary"
        >
          cancel
        </a>
        &nbsp;
        <button
          class="button"
          @click.prevent="handleSubmit"
        >
          Save
        </button>
      </p>
    </div>
  </form>
</template>

<script>
import LocationResult from '../models/LocationResult'
import HttpStatusCodes from '../../constants/HttpStatusCodes'

export default {
  data () {
    return {
      city: "",
      stateCode: "",
      countryCode: "",
      suggestions: [],
    }
  },

  props: {
    accountId: {
      type: [Number, Boolean],
      required: false,
      default: false,
    },

    teamId: {
      type: [Number, Boolean],
      required: false,
      default: false,
    },

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
    subject () {
      if (this.accountId) {
        return 'this person'
      } else if (this.teamId) {
        return 'this team'
      } else {
        return 'you'
      }
    },

    getCurrentLocationEndpoint () {
      return this._getEndpoint('current_location')
    },

    patchLocationEndpoint () {
      return this._getEndpoint('location')
    },

    params () {
      const rootParamName = `${this.scopeName}_location`
      let params = {}

      params[rootParamName] = {
        city: this.city,
        state_code: this.stateCode,
        country_code: this.countryCode,
      }

      return params
    },
  },

  methods: {
    handleSubmit () {
      window.axios.patch(this.patchLocationEndpoint, this.params)
        .then(({ status, data }) => {
          console.log(status, data)
        }).catch(err => {
          switch(err.response.status) {
            case HttpStatusCodes.MULTIPLE_CHOICES:
              this.suggestions = err.response.data.results.map(result => {
                return new LocationResult(result)
              })
            case HttpStatusCodes.NOT_FOUND:
              console.warn('geocoding results not found')
              this.$refs.cityField.focus()
            default:
              console.error(err)
          }
        })
    },

    resetForm () {
      this.city = ""
      this.stateCode = ""
      this.countryCode = ""
      this.$refs.cityField.focus()
    },

    initChosen () {
      const $country = $("#location_country")

      $country.chosen({
        allow_single_deselect: true,
      })

      $country.val(this.countryCode)
      $country.trigger("chosen:updated")
    },

    _getEndpoint (pathPart) {
      const endpointRoot = `/${this.scopeName}/${pathPart}`

      if (this.accountId) {
        return `${endpointRoot}?account_id=${this.accountId}`
      } else if (this.teamId) {
        return `${endpointRoot}?team_id=${this.teamId}`
      } else {
        return endpointRoot
      }
    },
  },
}
</script>

<style lang="scss" scoped>
</style>