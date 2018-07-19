import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import EmailValidation from 'registration/components/EmailValidation'

describe('EmailValidation Vue component', () => {
  it('mounts with an email field', () => {
    const wrapper = shallowMount(EmailValidation)
    wrapper.vm.email = 'joe@joesak.com'
    expect(wrapper.find('input[type=email]').element.value).toEqual('joe@joesak.com')
  })

  it('debounces the email validation method on email input', () => {
    const wrapper = shallowMount(EmailValidation)

    const emailWatcherSpy = jest.spyOn(wrapper.vm, 'debouncedEmailWatcher')

    wrapper.vm.email = 'joe@joesak.com'

    expect(emailWatcherSpy).toHaveBeenCalledTimes(1)
  })

  describe('#validateEmailInput()', () => {
    it('calls the validation service with the email', () => {
      const wrapper = shallowMount(EmailValidation, {
        watch: { email: jest.fn() },
      })

      wrapper.vm.email = 'joe@joesak.com'

      axios.mockResponseOnce('get', {
        "address": "foo@mailgun.net",
        "did_you_mean": null,
        "is_disposable_address": false,
        "is_role_address": true,
        "is_valid": true,
        "mailbox_verification": "true",
        "parts": {
            "display_name": null,
            "domain": "mailgun.net",
            "local_part": "foo"
        }
      })

      wrapper.vm.validateEmailInput()

      expect(axios.get).toHaveBeenCalledWith(
        `/validate_email?address=${encodeURIComponent('joe@joesak.com')}`
      )
    })
  })
})