
import 'axios'
import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'

import mockStore from 'registration/store/__mocks__'
import ChooseProfile from 'registration/components/ChooseProfile'

const localVue = createLocalVue()
localVue.use(Vuex)

describe("Registration::Components::ChooseProfile.vue", () => {
  let defaultWrapper

  beforeEach(() => {
    const defaultStore = mockStore.createMocks({
      actions: {
        updateProfileChoice ({ commit }, choice) {
          commit('profileChoice', choice)
        },
      },
    })

    defaultWrapper = shallowMount(
      ChooseProfile,
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
        methods: {
          getExpertiseOptions: jest.fn(() => {}),
        },
      }
    )
  })

  describe("computed.profileOptions", () => {
    it('is an empty array by default', () => {
      expect(defaultWrapper.vm.profileOptions).toEqual([])
    })
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