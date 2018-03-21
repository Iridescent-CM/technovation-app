import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'
import Vuetify from 'vuetify'

import _ from 'lodash'

Vue.use(Vuex)

Vue.use(Vuetify)

import VTooltip from 'v-tooltip';

import DivisionFilter from '../admin/DivisionFilter'
import SeasonFilter from '../admin/SeasonFilter'

import "../components/tooltip.scss";

Vue.use(TurbolinksAdapter);
Vue.use(VTooltip);

import 'vuetify/dist/vuetify.min.css'
import '../admin/main.scss'

const store = new Vuex.Store({
  state: {
    items: [],

    url: '/admin/participants.json?',

    searchFilters: {
      seasons: {
        items: [
          {
            value: 2018,
            selected: true,
          },
          {
            value: 2017,
            selected: false,
          },
          {
            value: 2016,
            selected: false,
          },
          {
            value: 2015,
            selected: false,
          },
        ],

        appendURLParams () {
          store.commit('appendURL', { })
        },
      },

      division: {
        junior: {
          paramName: 'division',
          paramValue: 'junior',
          value: true,

          setValue (bool) {
            this.value = bool
          },

          appendURLParams () {
            let payload = {}

            if (this.value) {
              payload.append = "accounts_grid[" + this.paramName + "][]=" +
                               this.paramValue
            }

            const senior = store.getters.searchFilters({
              name: 'division',
              value: 'senior',
            })

            if (senior.value) {
              payload.url += "&accounts_grid[" + senior.paramName + "][]=" +
                senior.paramValue
            }

            store.commit('appendURL', payload)
          },
        },

        senior: {
          paramName: 'division',
          paramValue: 'senior',
          value: true,

          setValue (bool) {
            this.value = bool
          },

          appendURLParams () {
            let payload = {}

            if (this.value) {
              payload.append = "accounts_grid[" + this.paramName + "][]=" +
                               this.paramValue
            }

            const junior = store.getters.searchFilters({
              name: 'division',
              value: 'junior',
            })

            if (junior.value) {
              payload.url += "&accounts_grid[" + junior.paramName + "][]=" +
                junior.paramValue
            }

            store.commit('appendURL', payload)
          },
        },
      },
    },
  },

  getters: {
    url (state) {
      return state.url
    },

    items (state) {
      return state.items
    },

    searchFilters: (state) => (opts) => {
      if (opts) {
        if (opts.value) {
          return state.searchFilters[opts.name][opts.value]
        } else {
          if (opts.name === 'selectedSeasons') {
            return _.filter(state.searchFilters.seasons.items, 'selected')
          } else {
            return _.map(state.searchFilters[opts.name].items, 'value')
          }
        }
      } else {
        return state.searchFilters
      }
    },
  },

  mutations: {
    appendURL (state, payload) {
      state.url += payload.url
    },

    paginateSearch (state, payload) {
      $.ajax({
        method: "GET",
        url: store.getters.url + "&page=" + payload.page,
        success: (resp) => { state.items = resp },
        error: (err) => { console.error(err) },
      })
    },

    initParticipants (state) {
      $.ajax({
        method: "GET",
        url: store.getters.url,
        success: (resp) => { state.items = resp },
        error: (err) => { console.error(err) },
      })
    },

    searchFilters (state, payload) {
      let filter

      if (payload.filterName) {
        filter = state.searchFilters[payload.filterRoot][payload.filterName]
      } else {
        filter = state.searchFilters[payload.filterRoot]
      }

      if (typeof payload.value === Array) {
        _.each(filter, f => { f.selected = payload.value.includes(f.value) })
      } else {
        filter.value = payload.value
      }

      filter.appendURLParams()

      $.ajax({
        method: "GET",
        url: store.getters.url,

        success: (resp) => {
          state.items = resp
        },

        error: (err) => {
          state.commit(
            'searchFilters',
            filter.name,
            filter.paramValue,
            !value
          )
          console.error(err)
        },
      })
    },
  },
})

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: "#app",

    data: {
      page: 1,

      headers: [
        { text: 'Last name', value: 'last_name' },
        { text: 'First name', value: 'first_name' },
        { text: 'Email', value: 'email' },
        { text: 'City', value: 'city' },
        { text: 'State', value: 'state_province' },
        { text: 'Country', value: 'country' },
      ],
    },

    store,

    computed: {
      items () {
        return this.$store.getters.items
      },
    },

    watch: {
      page (val) {
        this.$store.commit('paginateSearch', { page: val })
      },
    },

    components: {
      DivisionFilter,
      SeasonFilter,
    },

    mounted () {
      this.$store.commit('initParticipants')
    },
  });
});
