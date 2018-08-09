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
    defaultWrapper = shallowMount(
      BasicProfile,
      {
        localVue,
        store: mockStore.createMocks().store,
        methods: {
          getExpertiseOptions: jest.fn(() => {})
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
        'initWizard',
        {
          referredByOther: 'something',
        },
      )

      expect(defaultWrapper.vm.referredByOther).toEqual('something')
    })
  })
})