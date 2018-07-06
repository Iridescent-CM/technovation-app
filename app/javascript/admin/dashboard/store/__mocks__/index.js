import VuexMockStore from 'utilities/vuex-mock-store'

import state from '../state'
import getters from '../getters'
import mutations from '../mutations'

export default new VuexMockStore({
  state,
  getters,
  mutations,
})
