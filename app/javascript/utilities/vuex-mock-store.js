'use strict';

import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default class VuexMockStore {

  constructor(overrides = { state: {}, getters: {}, mutations: {}, actions: {} }) {
    if (!this.isObject(overrides.state))
      overrides.state = {}

    if (!this.isObject(overrides.getters))
      overrides.getters = {}

    if (!this.isObject(overrides.mutations))
      overrides.mutations = {}

    if (!this.isObject(overrides.actions))
      overrides.actions = {}

    this.store = {
      state: Object.assign({}, overrides.state),
      getters: Object.assign({}, overrides.getters),
      mutations: Object.assign({}, overrides.mutations),
      actions: Object.assign({}, overrides.actions),
    }
  }

  createMocks(custom = { getters: {}, mutations: {}, actions: {}, state: {} }) {
    const mockGetters = Object.assign({}, this.store.getters, custom.getters)
    const mockMutations = Object.assign({}, this.store.mutations, custom.mutations)
    const mockActions = Object.assign({}, this.store.actions, custom.actions)
    const mockState = Object.assign({}, this.store.state, custom.state)

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

  isObject(value) {
    return (value !== null && typeof value === 'object' && !Array.isArray(value))
  }
}