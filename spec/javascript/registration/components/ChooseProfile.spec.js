
import 'axios'
import { defaultWrapperWithVuex } from '../../__utils__/technovation-test-utils'
import ChooseProfile from 'registration/components/ChooseProfile'

import mockStore from 'registration/store/__mocks__'

describe("Registration::Components::ChooseProfile.vue", () => {
  let defaultWrapper

  beforeEach(() => {
    defaultWrapper = defaultWrapperWithVuex(
      ChooseProfile,
      mockStore,
      {
        actions: {
          updateProfileChoice ({ commit }, choice) {
            commit('profileChoice', choice)
          },
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