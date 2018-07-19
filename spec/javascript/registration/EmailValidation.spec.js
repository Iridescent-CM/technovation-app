import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import debounce from 'lodash/debounce'

import EmailValidation from 'registration/components/EmailValidation'

jest.mock('lodash/debounce', () => jest.fn(fn => fn()))

describe('EmailValidation Vue component', () => {
  it('mounts with an email field', () => {
    const wrapper = shallowMount(EmailValidation, { propsData: { apiKey: 'a' } })
    wrapper.vm.email = 'joe@joesak.com'
    expect(wrapper.find('input[type=email]').element.value).toEqual('joe@joesak.com')
  })

  it('debounces the email validation method on email input', () => {
    debounce.mockClear()

    const wrapper = shallowMount(EmailValidation, { propsData: { apiKey: 'a' } })

    const validateEmailInputSpy = jest.spyOn(wrapper.vm, 'validateEmailInput')

    wrapper.vm.email = 'joe@joesak.com'

    expect(debounce).toHaveBeenCalledTimes(1)
    expect(validateEmailInputSpy).toHaveBeenCalledTimes(1)
  })

  describe('#validateEmailInput()', () => {
    it('calls the validation service with the email', () => {
      const wrapper = shallowMount(EmailValidation, {
        propsData: {
          apiKey: 'abc123',
        },

        watch: {
          email: jest.fn(),
        },
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
        'https://api.mailgun.net/v3/address/validate',
        {
          auth: {
            username: 'api',
            password: 'abc123',
          },
          data: {
            address: encodeURIComponent('joe@joesak.com')
          },
        }
      )
    })
  })
})