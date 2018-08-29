import axios from 'axios'
import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'

import BasicProfile from 'registration/components/BasicProfile'
import mockStore from 'registration/store/__mocks__'

const localVue = createLocalVue()
localVue.use(Vuex)

describe("Registration::Components::BasicProfile.vue", () => {
  let defaultWrapper

  beforeEach(() => {
    const defaultStore = mockStore.createMocks()

    defaultWrapper = shallowMount(
      BasicProfile,
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

  describe("computed.referredByOther", () => {
    it("is null by default", () => {
      expect(defaultWrapper.vm.referredByOther).toBe(null)
    })

    it("can be set during initWizard", () => {
      defaultWrapper.vm.$store.dispatch(
        'registration/initWizard',
        {
          referredByOther: 'something',
        },
      )

      expect(defaultWrapper.vm.referredByOther).toEqual('something')
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