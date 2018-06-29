import Vue from 'vue'
import Vuex from 'vuex'

import vuexStore from '../index'

Vue.use(Vuex)

vuexStore.actions = {}

// eslint-disable-next-line no-underscore-dangle
export function __createMocks(custom = { getters: {}, mutations: {}, actions: {}, state: {} }) {
  const mockGetters = Object.assign({}, vuexStore.getters, custom.getters)
  const mockMutations = Object.assign({}, vuexStore.mutations, custom.mutations)
  const mockActions = Object.assign({}, vuexStore.actions, custom.actions)
  const mockState = Object.assign({}, vuexStore.state, custom.state)

  return {
    getters: mockGetters,
    mutations: mockMutations,
    actions: mockActions,
    state: mockState,
    store: new Vuex.Store({
      getters: mockGetters,
      mutations: mockMutations,
      actions: mockActions,
      state: mockState,
    }),
  }
}

export const store = __createMocks().store