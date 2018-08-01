import 'axios'
import { defaultWrapperWithVuex } from '../../__utils__/technovation-test-utils'
import BasicProfile from 'registration/components/BasicProfile'

import mockStore from 'registration/store/__mocks__'

describe("Registration::Components::BasicProfile.vue", () => {
  let defaultWrapper

  beforeEach(() => {
    defaultWrapper = defaultWrapperWithVuex(BasicProfile, mockStore)
  })

  describe("computed.referredByOther", () => {
    it("is null by default", () => {
      expect(defaultWrapper.vm.referredByOther).toBe(null)
    })

    it("can be set during initWizard", () => {
      defaultWrapper.vm.$store.dispatch(
        'initWizard',
        {
          previousAttempt: JSON.stringify(
            {
              data: {
                attributes: {
                  referredByOther: 'something',
                },
              },
            }
          )
        }
      )

      expect(defaultWrapper.vm.referredByOther).toEqual('something')
    })
  })
})