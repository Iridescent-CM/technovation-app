import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

import state from './state'
import getters from './getters'
import mutations from './mutations'
import actions from './actions'

import { storeModule as registration } from 'registration/store'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    registration,
    student: {
      state,
      getters,
      mutations,
      actions,
    },
  },
})