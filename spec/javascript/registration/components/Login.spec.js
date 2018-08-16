import 'axios'
import { defaultWrapperWithVuex } from '../../__utils__/technovation-test-utils'
import Login from 'registration/components/Login'

import mockStore from 'registration/store/__mocks__'

describe("Registration::Components::Login.vue", () => {
  let defaultWrapper

  beforeEach(() => {
    defaultWrapper = defaultWrapperWithVuex(
      Login,
      mockStore,
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