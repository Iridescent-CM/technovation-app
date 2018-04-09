<template>
  <form @submit.prevent="handleSubmit" v-if="showForm">
    <template v-if="candidates.length">

      <p>We found more than one possible result, please choose the best option.</p>

      <ol class="candidates-list">
        <li
          v-for="(candidate, i) in candidates"
          :key="i"
          @click="selectCandidate(candidate)"
        >
          <div
            class="checked"
            v-show="candidate.selected"
          >
            <icon name="check-circle" color="228b22" />
          </div>

          <div
            class="unchecked"
            v-show="!candidate.selected"
          >
            <icon name="check-circle-o" />
          </div>

          <div class="city">{{ candidate.city }}</div>
          <div class="state">{{ candidate.state }}</div>
          <div class="country">{{ candidate.country }}</div>
        </li>
      </ol>
    </template>

    <div :class="['field', errors.city.length ? 'field_with_errors' : '']">
      <label for="city">City</label>
      <input id="city" type="text" v-model="city" />

      <div v-if="errors.city.length" class='error'>
        {{ errors.city }}
      </div>
    </div>

    <div :class="['field', errors.state.length ? 'field_with_errors' : '']">
      <label for="state">State / Province</label>
      <input
        id="state"
        type="text"
        v-model="state"
      />

      <div v-if="errors.state.length" class='error'>
        {{ errors.state }}
      </div>
    </div>

    <div
      id="autocomplete-field"
      :class="['field', errors.country.length ? 'field_with_errors' : '']"
    >
      <label for="country">Country</label>
      <input
        id="country"
        type="text"
        v-model="country"
        :autocomplete="disableBrowserSpecificAutofill"
        autocorrect="off"
        placeholder="Start typing to find your country"
        @focus="initCountryList"
        @input="initCountryList"
        @blur="showCountryList = false"
        @keyup.up.prevent="highlightPreviousCountry"
        @keyup.down.prevent="highlightNextCountry"
        @keydown.enter.prevent="selectHighlightedCountry"
      />

      <ol v-show="showCountryList" class="autocomplete-list">
        <li
          v-for="(country, i) in filteredCountries"
          :key="country[1]"
          @mouseenter="highlightCountry(i)"
          @mousedown.prevent="selectHighlightedCountry"
        >
          {{ country[0] }}
        </li>
      </ol>

      <div v-if="errors.country.length" class='error'>
        {{ errors.country }}
      </div>
    </div>

    <div class="actions">
      <button class="button">Save</button>
    </div>
  </form>

  <div v-else>
    <icon name="refresh" size="16" className="spin" />
    <template v-if="appIsReady">
      Getting your location...
    </template>

    <template v-else>
      Initiating location form...
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Icon from '../../components/Icon'

export default {
  data () {
    return {
      city: '',
      state: '',
      country: '',

      showForm: false,
      showCountryList: false,
      highlightedCountryIdx: 0,

      errors: {
        city: '',
        state: '',
        country: '',
      },

      candidates: [],
    }
  },

  computed: {
    ...mapState(['appIsReady', 'countries']),

    filteredCountries () {
      const pattern = new RegExp(`^${this.country}`, 'i')
      const countries = Array.from(this.countries).sort((a, b) => {
        if (a[0].toLowerCase() > b[0].toLowerCase())
          return 1
        if (a[0].toLowerCase() < b[0].toLowerCase())
          return -1
        return 0
      })
      return countries.filter(country => country[0].match(pattern))
    },

    disableBrowserSpecificAutofill () {
      const isFirefox = typeof InstallTrigger !== 'undefined'
      const isSafari = /constructor/i.test(window.HTMLElement) ||
        (p => p.toString() === "[object SafariRemoteNotification]")(
          !window['safari'] ||
            (typeof safari !== 'undefined' && safari.pushNotification)
        )

      if (isFirefox || isSafari)
        return 'off'
      return 'nope'
    }
  },

  components: {
    Icon,
  },

  methods: {
    selectCandidate (candidate) {
      this.candidates.forEach(c => c.selected = false)
      this.city = candidate.city
      this.state = candidate.state
      this.country = candidate.country
      candidate.selected = true
    },

    handleSubmit () {
      if (!this.city.length)    this.errors.city = 'cannot be blank'
      if (!this.state.length)   this.errors.state = 'cannot be blank'
      if (!this.country.length) this.errors.country = 'cannot be blank'

      const errorVals = Object.values(this.errors)

      if (!errorVals.some(v => v.length)) {
        let data = new FormData()

        data.append('account[city]', this.city)
        data.append('account[state_province]', this.state)
        data.append('account[country]', this.country)

        $.ajax({
          method: "PATCH",
          url: "/account_locations",
          data: data,
          contentType: false,
          processData: false,
        }).then(resp => {
          if (resp.candidates) {
            debugger
          } else {
            this.$router.push(this.$route.query.return_to || '/')
          }
        })
      } else {
        console.error(this.errors)
      }
    },

    handleCoordinates (pos) {
      const lat = pos.coords.latitude
      const lng = pos.coords.longitude

      $.getJSON(`/geolocation_results?lat=${lat}&lng=${lng}`, resp => {
        // if (resp.length == 1) {
        //   this.city = resp[0].city
        //   this.state = resp[0].state
        //   this.country = resp[0].country
        // } else if (resp.length) {
          this.candidates = resp
        // }

        this.showForm = true
      })
    },

    handleError (err) {
      console.error(err)
      this.showForm = true
    },

    initCountryList () {
      this.showCountryList = true
      this.highlightCountry(0)
    },

    highlightCountry (i) {
      const items = document.querySelectorAll('.autocomplete-list li')
      items.forEach(el => {
        el.classList.remove('highlighted')
      })

      const el = items[i]
      el.classList.add('highlighted')
      this.highlightedCountryIdx = i
    },

    highlightPreviousCountry () {
      if (this.highlightedCountryIdx - 1 < 0) {
        this.highlightCountry(this.filteredCountries.length - 1)
      } else {
        this.highlightCountry(this.highlightedCountryIdx - 1)
      }

      this.ensureHighlightedIsVisible()
    },

    highlightNextCountry () {
      if (this.highlightedCountryIdx + 1 > this.filteredCountries.length - 1) {
        this.highlightCountry(0)
      } else {
        this.highlightCountry(this.highlightedCountryIdx + 1)
      }

      this.ensureHighlightedIsVisible()
    },

    ensureHighlightedIsVisible () {
      const items = document.querySelectorAll('.autocomplete-list li')
      const el = items[this.highlightedCountryIdx]
      const scrollTop = el.offsetTop
      document.querySelector('.autocomplete-list').scrollTop = scrollTop
    },

    selectHighlightedCountry () {
      const country = this.filteredCountries[this.highlightedCountryIdx]
      this.country = country[0]
      this.showCountryList = false
    },
  },

  mounted () {
    this.$store.dispatch('initApp').then(() => {
      this.candidates = [
        { selected: false, city: "Zapopan", state: "Jal.", country: "MX" },
        { selected: false, city: "Monterrey", state: "N.L.", country: "MX" },
        { selected: false, city: "Los Angeles", state: "CA", country: "US" },
      ]
      this.showForm = true

      // if ("geolocation" in navigator) {
      //   navigator.geolocation.getCurrentPosition(
      //     this.handleCoordinates,
      //     this.handleError
      //   )
      // } else {
      //   this.showForm = true
      // }
    })
  }
}
</script>

<style lang="scss" scoped>
#autocomplete-field {
  position: relative;
}

.autocomplete-list {
  position: absolute;
  top: 63px;
  left: 0;
  z-index: 1058;
  width: 100%;
  list-style: none;
  padding: 0;
  margin: 0;
  border: solid #999;
  border-width: 0 1px 1px;
  box-shadow: 0.1rem 0.1rem 0.1rem rgba(0, 0, 0, 0.2);
  max-height: 150px;
  overflow-y: scroll;
  background: white;

  li {
    padding: 0.3rem 0.5rem;
    border-bottom: 1px solid rgba(0, 0, 0, 0.2);
    cursor: pointer;

    &.highlighted {
      background: #ACCEF7;
    }
  }
}

.candidates-list {
  list-style: none;
  margin: 1rem auto;
  padding: 0;
  max-width: 30vw;

  li {
    display: flex;
    justify-content: space-around;
    padding: 1rem;
    cursor: pointer;
    transition: background-color 0.2s;

    &:hover {
      background: #ACCEF7;
    }
  }
}

.unchecked {
  opacity: 0.4;
}
</style>