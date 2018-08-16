import VuexMockStore from 'utilities/vuex-mock-store'

import state from '../state'
import getters from '../getters'
import mutations from '../mutations'
import actions from '../actions'

export default new VuexMockStore({
  state,
  getters,
  mutations,
  actions,
})