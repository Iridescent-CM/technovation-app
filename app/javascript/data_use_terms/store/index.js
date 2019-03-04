import Vue from 'vue';
import Vuex from 'vuex';

import state from 'registration/store/state';
import getters from 'registration/store/getters';
import mutations from 'registration/store/mutations';
import actions from './actions';

Vue.use(Vuex);

export const storeModule = {
  state,
  getters,
  mutations,
  actions,
};

export default new Vuex.Store({
  modules: {
    authenticated: {
      namespaced: true,
      state: {
        currentAccount: null,
      },
    },
    registration: {
      namespaced: true,
      ...storeModule,
    },
  },
});