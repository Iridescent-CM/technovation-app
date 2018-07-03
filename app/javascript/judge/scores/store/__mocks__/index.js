import VuexMockStore from '__mocks__/vuex-mock-store'

import state from '../state'
import * as getters from '../getters'
import * as mutations from '../mutations'

export default new VuexMockStore({
  state,
  getters,
  mutations,
})
