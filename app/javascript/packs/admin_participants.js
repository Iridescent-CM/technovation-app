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

const ROOT_URL = '/admin/participants.json?'

const store = new Vuex.Store({
  state: {
    items: [],
    searchFilters: [],
  },

  getters: {
    items (state) {
      return state.items
    },
  },

  mutations: {
    searchFilters (state, payload) {
      const idx = _.findIndex(state.searchFilters, f => {
        return f.name == payload.name
      })

      if (idx === -1) {
        state.searchFilters.push(payload)
      } else {
        state.searchFilters[idx] = payload
      }

      let url = ROOT_URL

      _.each(state.searchFilters, f => {
        if (f.multiple) {
          _.each(f.value, v => {
            url += f.param + '=' + v + '&'
          })
        } else {
          url += f.param + '=' + f.value + '&'
        }
      })

      $.ajax({
        method: "GET",
        url: url,
        success: (resp) => { state.items = resp },
        error: (err) => { console.error(err) },
      })
    },

    initParticipants (state) {
      $.ajax({
        method: "GET",
        url: ROOT_URL,
        success: (resp) => { state.items = resp },
        error: (err) => { console.error(err) },
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
        this.$store.commit('searchFilters', {
          param: 'page',
          value: val,
        })
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
