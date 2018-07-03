import VuexMockStore from '__mocks__/vuex-mock-store'

import { state, getters, mutations } from '../index'

export default new VuexMockStore({
  state,
  getters,
  mutations,
})
