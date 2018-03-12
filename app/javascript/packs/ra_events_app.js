import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'

Vue.use(Vuex)

import VTooltip from 'v-tooltip';

import EventsTable from './EventsTable';
import EventForm from './EventForm';

import "flatpickr/dist/themes/material_green.css";
import "tooltip.scss";

import ElementUI from 'element-ui'
import locale from 'element-ui/lib/locale/lang/en'
import 'element-ui/lib/theme-chalk/index.css'

Vue.use(TurbolinksAdapter);
Vue.use(VTooltip);
Vue.use(ElementUI, { locale });

const store = new Vuex.Store({
  state: {
    teams: [],
  },

  mutations: {
    addTeam (state, team) {
      const idx = _.findIndex(state.teams, t => {
        return t.id === team.id
      })

      if (idx === -1)
        state.teams.push(team)
    },

    removeTeam (state, team) {
      const idx = _.findIndex(state.teams, t => {
        return t.id === team.id
      })

      if (idx !== -1)
        state.teams.splice(idx, 1)
    },
  }
})

$(document).on('ready turbolinks:load', () => {
  new Vue({
    el: "#app",

    store,

    components: {
      EventsTable,
      EventForm,
    },
  });
});
