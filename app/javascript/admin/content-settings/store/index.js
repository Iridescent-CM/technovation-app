import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

import state from './state'

const getters = {}
const mutations = {}
const actions = {}

Vue.use(Vuex)

export default new Vuex.Store({
  state,
  getters,
  mutations,
  actions,
})
