import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

import state from './state'
import getters from './getters'
import mutations from './mutations'
import actions from './actions'

Vue.use(Vuex)

export const storeModule = {
  state,
  getters,
  mutations,
  actions,
}

export default new Vuex.Store(storeModule)