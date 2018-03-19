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

        appendURLParams (urlRoot, paramRoot) {
          return urlRoot + "?" + paramRoot
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

          appendURLParams (urlRoot, paramRoot) {
            let url = urlRoot + "?" + paramRoot

            if (this.value) url += "[" + this.paramName + "][]=" +
                                   this.paramValue

            const senior = store.getters.searchFilters({
              name: 'division',
              value: 'senior',
            })

            if (senior.value) {
              url += "&" + paramRoot + "[" + senior.paramName + "][]=" +
                senior.paramValue
            }

            return url
          },
        },

        senior: {
          paramName: 'division',
          paramValue: 'senior',
          value: true,

          setValue (bool) {
            this.value = bool
          },

          appendURLParams (urlRoot, paramRoot) {
            let url = urlRoot + "?" + paramRoot

            if (this.value) url += "[" + this.paramName + "][]=" +
                                   this.paramValue

            const junior = store.getters.searchFilters({
              name: 'division',
              value: 'junior',
            })

            if (junior.value) {
              url += "&" + paramRoot + "[" + junior.paramName + "][]=" +
                junior.paramValue
            }

            return url
          },
        },
      },
    },
  },

  getters: {
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
    searchFilters (state, opts) {
      let filter

      if (opts.filterName) {
        filter = state.searchFilters[opts.filterRoot][opts.filterName]
      } else {
        filter = state.searchFilters[opts.filterRoot]
      }

      if (typeof opts.value === Array) {
        _.each(filter, f => { f.selected = opts.value.includes(f.value) })
      } else {
        filter.value = opts.value
      }

      const paramRoot = "accounts_grid"
      const urlRoot = "/admin/participants.json"
      const url = filter.appendURLParams(urlRoot, paramRoot)

      $.ajax({
        method: "GET",
        url: url,

        success: (resp) => {
          console.log(resp)
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

    store,

    computed: {
    },

    components: {
      DivisionFilter,
      SeasonFilter,
    },

    mounted () {
      console.log('admin participants')
    },
  });
});
