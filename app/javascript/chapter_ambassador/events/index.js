import Vue from 'vue'
import Vuex from 'vuex'

import EventsTable from './EventsTable'
import EventForm from './EventForm'

import "flatpickr/dist/themes/material_green.css"
import "../../components/tooltip.scss"

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    teams: [],
  },

  mutations: {
    addTeam (state, team) {
      const idx = state.teams.findIndex((t) => {
        return t.id === team.id
      })

      if (idx === -1)
        state.teams.push(team)
    },

    removeTeam (state, team) {
      const idx = state.teams.findIndex((t) => {
        return t.id === team.id
      })

      if (idx !== -1)
        state.teams.splice(idx, 1)
    },
  }
})

document.addEventListener('DOMContentLoaded', () => {
  const appEl = document.querySelector("#app")

  if (appEl != undefined) {
    new Vue({
      el: appEl,
      store,
      components: {
        EventsTable,
        EventForm,
      },
    });
  }
});
