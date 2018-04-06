import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    appIsReady: false,
    countries: [],
  },

  mutations: {
    ready (state) {
      state.appIsReady = true
    },

    countries (state, countries) {
      state.countries = countries
    },
  },

  actions: {
    initApp ({ commit }) {
      return new Promise((resolve, reject) => {
        $.getJSON('/countries', resp => {
          commit('countries', resp)
          commit('ready')
          resolve()
        })
      })
    },
  },
})