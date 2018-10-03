import 'axios'
import { mount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'

import LocationComponent from 'registration/components/Location'

import mockStore from 'registration/store/__mocks__'

const localVue = createLocalVue()
localVue.use(Vuex)

describe("Registration::Components::Location.vue", () => {
  let defaultWrapper

  beforeEach(() => {
    const defaultStore = mockStore.createMocks()

    defaultWrapper = mount(
      LocationComponent,
      {
        localVue,
        store: new Vuex.Store({
          modules: {
            registration: {
              namespaced: true,
              state: defaultStore.state,
              getters: defaultStore.getters,
              mutations: defaultStore.mutations,
              actions: defaultStore.actions,
            },
          },
        }),
      }
    )
  })

  describe('markup', () => {
    it('has one button element to prevent navigation issues when submitting', () => {
      // Note: if this test is failing, you can change <button> to
      // <a class="button"> for a similar effect
      const buttons = defaultWrapper.findAll('button')

      expect(buttons.length).toEqual(1)
    })
  })
})