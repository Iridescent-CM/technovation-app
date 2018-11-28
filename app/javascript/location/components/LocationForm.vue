<template>
  <form
    class="panel panel--contains-bottom-bar panel--contains-top-bar"
    @submit.prevent="handleSubmit"
  >
    <div class="panel__top-bar">
      Confirm {{ subjectPossessive }} region
    </div>

    <div
      v-if="loading"
      class="panel__content"
    >
      <div class="padding--t-b-large text-align--center">
        <p><icon name="spinner" className="spin" /></p>
        <p>Loading location form</p>
      </div>
    </div>

    <div
      v-else
      class="panel__content"
    >
      <div class="padding--t-medium">
        <label for="location_country">Country / Territory</label>

        <vue-select
          ref="countryField"
          :select-on-tab="true"
          input-id="location_country"
          :options="countries"
          v-model="country"
        />

        <label for="location_state">State / Province{{ optionalStateLabel }}</label>

        <vue-select
          v-if="subregions.length && country"
          ref="stateField"
          :select-on-tab="true"
          input-id="location_state"
          :options="subregions"
          v-model="state"
        />
        <p v-else-if="!country">
          Please select a country first
        </p>
        <p v-else-if="!subregions.length">
          <icon name="spinner" className="spin" size="14" />
          Loading States / Provinces
        </p>

        <label for="location_city">City</label>

        <input
          type="text"
          id="location_city"
          ref="cityField"
          autocomplete="address-level2"
          v-model="city"
        />

        <a
          href="#"
          class="color--danger font-size--small"
          id="location_form_reset"
          @click.prevent="resetForm"
          v-if="formHasInput"
        >
          reset this form
        </a>
      </div>
    </div>

    <div class="panel__bottom-bar">
      <a
        class="button float--left"
        @click.prevent="handleBack"
        v-if="showBackBtn"
      >
        Back
      </a>
      <p class="padding--none margin--none">
        <button
          id="location_submit_button"
          class="button"
          :disabled="searching || loading"
          @click.prevent="handleSubmit"
        >
          Next
        </button>
      </p>
    </div>
  </form>
</template>

<script>
import HttpStatusCodes from '../../constants/HttpStatusCodes'
import Icon from 'components/Icon'
import VueSelect from '@vendorjs/vue-select'

export default {
  components: {
    Icon,
    VueSelect,
  },

  data () {
    return {
      city: '',
      state: '',
      country: '',
      countries: [],
      loading: true,
      subregions: [],
    }
  },

  props: {
    wizardToken: {
      type: String,
      required: false,
      default: '',
    },

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

    value: {
      type: Object,
      required: false,
      default: null,
    },

    handleBack: {
      type: Function,
      required: false,
      default: () => history.back(),
    },

    showBackBtn: {
      type: Boolean,
      required: false,
      default: false,
    },

    handleConfirm: {
      type: Function,
      required: false,
      default: () => history.back(),
    },
  },

  created () {
    const countriesInitialized = window.axios.get('/public/countries').then(({ data }) => {
      this.countries = data
    })

    const currentLocationInitialized = new Promise((resolve, reject) => {
      if (this.value) {
        this.city = this.value.city
        this.state = this.value.state
        this.country = this.value.country
        resolve()
      } else {
        window.axios.get(this.getCurrentLocationEndpoint).then(({ data }) => {
          this.city = data.city
          this.state = data.state
          this.country = data.country
          resolve()
        })
      }
    })

    Promise.all([countriesInitialized, currentLocationInitialized]).then(() => {
      this.loading = false
    })
  },

  computed: {
    countryDetectedInStateOptionalList () {
      if (!this.country || !this.country.length)
        return false

      return this.country.match(/^\s*(hong\s*kong|hk)\s*$/i) ||
              this.country.match(/^\s*(palestine|ps)\s*/i) ||
                this.country.match(/^\s*(india|ind?)\s*$/i) ||
                  this.country.match(/^\s*(taiwan,?.*|tw)\s*$/i)
    },

    optionalStateLabel () {
      if (this.countryDetectedInStateOptionalList)
        return ' (Optional)'

      return ''
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

    formHasInput () {
      return (this.city && this.city.length) ||
              (this.state && this.state.length) ||
                (this.country && this.country.length)
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
        state: this.state,
        country: this.country,
        token: this.wizardToken,
      }

      return params
    },

    searching () {
      return !this.countries.length || !this.subregions.length
    },
  },

  watch: {
    city (value) {
      this.$emit('input', Object.assign({}, {
        city: value,
        state: this.state,
        country: this.country,
      }))
    },

    state (value) {
      this.$emit('input', Object.assign({}, {
        city: this.city,
        state: value,
        country: this.country,
      }))
    },

    country (value) {
      // Reset the subregions drop-down
      this.subregions = []

      if (!value) {
        this.state = ''
      } else {
        // Fetch the subregions for this country for the drop-down
        const countryName = encodeURIComponent(value)
        window.axios.get(`/public/countries?name=${countryName}`)
          .then(({ data }) => {
            this.subregions = data

            if (!this.subregions.includes(this.state)) {
              this.state = ''
            }

            this.$emit('input', Object.assign({}, {
              city: this.city,
              state: this.state,
              country: value,
            }))
          })
      }
    },
  },

  methods: {
    handleSubmit () {
      window.axios.post(this.patchLocationEndpoint, this.params)
        .then(() => {
          this.handleConfirm()
        }).catch(err => {
          console.error(err)
        })
    },

    resetForm () {
      this.city = ''
      this.state = ''
      this.country = ''
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
label:not(:first-child) {
  margin: 2rem 0 0;
}

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
  overflow: hidden; // Or flex might break
  list-style: none;
}

.Rtable--3cols > .Rtable-cell  { width: 33.33%; }
</style>