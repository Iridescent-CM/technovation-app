
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
})