import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'

const localVue = createLocalVue()
localVue.use(Vuex)

export const defaultWrapperWithVuex = (component, mockStore) => {
  return shallowMount(
    component,
    {
      localVue,
      store: mockStore.createMocks({
        actions: {
          updateBirthdate ({ commit }, attributes) {
            commit('birthDate',  attributes)
          },
        }
      }).store,
    }
  )
}