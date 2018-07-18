<template>
  <form
    class="panel panel--contains-bottom-bar panel--contains-top-bar"
    @submit.prevent="handleSubmit"
  >
    <div class="panel__top-bar">
      Confirm the location that we have on file for {{ subject }}
    </div>

    <div
      v-if="isNotFound"
      class="flash flash--error"
    >
      We're sorry, but we cannot find a location with that information.
    </div>

    <div class="panel__content">
      <template v-if="savedLocation">
        We have saved {{ subjectPossessive }} location as:

        <div class="Rtable Rtable--3cols">
          <div class="Rtable-cell"><h6>City</h6></div>
          <div class="Rtable-cell"><h6>State / Province</h6></div>
          <div class="Rtable-cell"><h6>Country / Territory</h6></div>
        </div>

        <div class="Rtable Rtable--3cols">
          <div class="Rtable-cell">
            {{ savedLocation.city || "(no city)" }}
          </div>

          <div class="Rtable-cell">
            {{ savedLocation.stateCode || "(no state/province)" }}
          </div>

          <div class="Rtable-cell">
            {{ savedLocation.country || "(no country)" }}
          </div>
        </div>
      </template>

      <template v-else>
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

        <input
          type="text"
          id="location_country"
          v-model="countryCode"
        />

        <a
          href="#"
          class="color--danger font-size--small"
          @click.prevent="resetForm"
        >
          reset this form
        </a>
      </template>
    </div>

    <template v-if="suggestions.length">
      <div class="flash">
        We couldn't match results to your information.<br />
        Change the form and try again, or select a result below.
      </div>

      <div class="Rtable Rtable--3cols">
        <div class="Rtable-cell"><h6>City</h6></div>
        <div class="Rtable-cell"><h6>State / Province</h6></div>
        <div class="Rtable-cell"><h6>Country / Territory</h6></div>
      </div>

      <div
        class="Rtable Rtable--3cols suggestion"
        v-for="suggestion in suggestions"
        :key="suggestion.id"
        @click="handleSuggestionClick(suggestion)"
      >
        <div class="Rtable-cell">
          {{ suggestion.city || "(no city)" }}
        </div>

        <div class="Rtable-cell">
          {{ suggestion.stateCode || "(no state/province)" }}
        </div>

        <div class="Rtable-cell">
          {{ suggestion.country || "(no country)" }}
        </div>
      </div>
    </template>

    <div class="panel__bottom-bar">
      <p class="padding--none margin--none">
        <a
          href="#"
          class="color--secondary"
          @click.prevent="handleCancel"
        >
          {{ cancelText }}
        </a>
        &nbsp;
        <button
          class="button"
          :disabled="searching"
          @click.prevent="handleSubmit"
        >
          {{ submitText }}
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
      savedLocation: null,
      searching: false,
      status: null,
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

  computed: {
    cancelText () {
      if (this.savedLocation) {
        return 'change location'
      } else {
        return 'cancel'
      }
    },

    submitText () {
      if (this.savedLocation) {
        return 'Confirm'
      } else {
        return 'Next'
      }
    },

    subject () {
      if (this.accountId) {
        return 'this person'
      } else if (this.teamId) {
        return 'this team'
      } else {
        return 'you'
      }
    },

    subjectPossessive () {
      if (this.accountId) {
        return "this person's"
      } else if (this.teamId) {
        return "this team's"
      } else {
        return 'your'
      }
    },

    isNotFound () {
      return this.status === HttpStatusCodes.NOT_FOUND
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

    countryOptions () {
      return this.countries.map(country => {
        return {
          label: country[0],
          value: country[1],
        }
      })
    },
  },

  watch: {
    status (newStatus) {
      switch(newStatus) {
        case HttpStatusCodes.NOT_FOUND:
          console.warn('geocoding results not found')
          this.$refs.cityField.focus()
        default:
          // no op
      }
    },
  },

  methods: {
    handleSubmit () {
      if (this.savedLocation) {
        history.back()
      } else {
        this.suggestions = []
        this.searching = true

        window.axios.patch(this.patchLocationEndpoint, this.params)
          .then(({ status, data }) => {
            this.handleOKResponse(status, data)
          }).catch(err => {
            this.handleErrorResponse(err)
          })
      }
    },

    handleCancel () {
      if (this.savedLocation) {
        this.resetForm()
      } else {
        history.back()
      }
    },

    handleSuggestionClick (suggestion) {
      this.city = suggestion.city
      this.stateCode = suggestion.stateCode
      this.countryCode = suggestion.countryCode
      this.handleSubmit()
    },

    handleOKResponse (status, data) {
      this.searching = false
      this.status = status
      this.savedLocation = new LocationResult(data.results[0])
      console.log('OK', status, data)
    },

    handleErrorResponse (err) {
      console.error('ERR', err)

      this.searching = false
      this.status = err.response.status

      if (this.status === HttpStatusCodes.MULTIPLE_CHOICES) {
        this.suggestions = err.response.data.results.map(result => {
          return new LocationResult(result)
        })
      }
    },

    handleCountryChange (value) {
      const country = Object.assign({}, value)
      if (country.value) this.countryCode = country.value
    },

    resetForm () {
      this.city = ""
      this.stateCode = ""
      this.countryCode = ""
      this.suggestions = []
      this.savedLocation = null
      this.status = null
      this.searching = false
      this.$refs.cityField.focus()
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
.Rtable {
  display: flex;
  flex-wrap: wrap;
  margin: 0;
  padding: 0;
}

.suggestion {
  transition: background-color 0.2s;

  &:hover {
    background: rgba(135, 206, 235, 0.7)
  }

  .Rtable-cell {
    cursor: pointer;
  }
}

.Rtable-cell {
  flex-grow: 1;
  width: 100%;  // Default to full width
  padding: 0.8em 1.2em;
  overflow: hidden; // Or flex might break
  list-style: none;
}

.Rtable--3cols > .Rtable-cell  { width: 33.33%; }
</style>