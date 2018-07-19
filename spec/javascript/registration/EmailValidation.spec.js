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

      axios.mockResponseOnce('get', {})

      wrapper.vm.validateEmailInput()

      expect(axios.get).toHaveBeenCalledWith(
        `/validate_email?address=${encodeURIComponent('joe@joesak.com')}`
      )
    })

    it('detects invalid email', (done) => {
      const wrapper = shallowMount(EmailValidation)

      axios.mockResponse('get', {
        "is_valid": false,
      })

      wrapper.vm.email = 'invalid'
      wrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(wrapper.vm.validationStatus).toBe(false)
        done()
      })
    })

    it('detects temporary email', (done) => {
      const wrapper = shallowMount(EmailValidation)

      axios.mockResponse('get', {
        "is_disposable_address": true,
      })

      wrapper.vm.email = 'something@disposable.com'
      wrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(wrapper.vm.isDisposableAddress).toBe(true)
        done()
      })
    })

    it('detects a "did you mean...?" suggestion', (done) => {
      const wrapper = shallowMount(EmailValidation)

      axios.mockResponse('get', {
        "did_you_mean": "joe@gmail.com",
      })

      wrapper.vm.email = 'joe@gmil.com'
      wrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(wrapper.vm.didYouMean).toEqual("joe@gmail.com")
        done()
      })
    })

    it('detects a mailbox_verification', (done) => {
      const wrapper = shallowMount(EmailValidation)

      axios.mockResponse('get', {
        "mailbox_verification": "true",
      })

      wrapper.vm.email = 'exists@gmail.com'
      wrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(wrapper.vm.mailboxVerification).toBe(true)
        done()
      })
    })

    it('detects a failed mailbox_verification', (done) => {
      const wrapper = shallowMount(EmailValidation)

      axios.mockResponse('get', {
        "mailbox_verification": "false",
      })

      wrapper.vm.email = 'missing@gmail.com'
      wrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(wrapper.vm.mailboxVerification).toBe(false)
        done()
      })
    })

    it('detects a duplicate email', (done) => {
      const wrapper = shallowMount(EmailValidation)

      axios.mockResponse('get', {
        "is_taken": true,
      })

      wrapper.vm.email = 'taken@gmail.com'
      wrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(wrapper.vm.emailIsTaken).toBe(true)
        done()
      })
    })
  })
})