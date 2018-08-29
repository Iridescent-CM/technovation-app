import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'

const localVue = createLocalVue()
localVue.use(Vuex)

export const defaultWrapperWithVuex = (component, mockStore, overrides) => {
  return shallowMount(
    component,
    {
      localVue,
      store: mockStore.createMocks({
        ...overrides,
      }).store,
    }
  )
}