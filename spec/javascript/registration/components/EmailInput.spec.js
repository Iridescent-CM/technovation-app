import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import axios from 'axios'

import mockStore from 'registration/store/__mocks__'
import EmailInput from 'registration/components/EmailInput'

const localVue = createLocalVue()
localVue.use(Vuex)

let defaultWrapper

describe('EmailInput Vue component', () => {
  beforeEach(() => {
    defaultWrapper = shallowMount(
      EmailInput,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )

    // store posts the email to rails for saving
    // server must return an OK response for the
    // store to commit it to state
    axios.mockResponse('post', {
      data: {
        attributes: {
          email: 'joe@joesak.com'
        }
      }
    })
  })

  it('mounts with an email field', (done) => {
    defaultWrapper.vm.email = 'joe@joesak.com'

    setImmediate(() => {
      expect(defaultWrapper.find('input[type=email]').element.value)
        .toEqual('joe@joesak.com')
      done()
    })
  })

  it('debounces the email validation method on email input', (done) => {
    const emailWatcherSpy = jest.spyOn(
      defaultWrapper.vm,
      'debouncedEmailWatcher'
    )

    defaultWrapper.vm.email = 'joe@joesak.com'

    setImmediate(() => {
      expect(emailWatcherSpy).toHaveBeenCalledTimes(1)
      done()
    })
  })

  describe('#validateEmailInput()', () => {
    it('calls the validation service with the email', (done) => {
      const wrapper = shallowMount(
        EmailInput,
        {
          localVue,
          store: mockStore.createMocks().store,
          watch: { email: jest.fn() },
        }
      )

      wrapper.vm.email = 'joe@joesak.com'

      setImmediate(() => {
        axios.mockResponseOnce('get', {})

        wrapper.vm.validateEmailInput()

        expect(axios.get).toHaveBeenCalledWith(
          `/public/email_validations/new?address=${encodeURIComponent('joe@joesak.com')}`
        )
        done()
      })
    })

    it('detects invalid email', (done) => {
      axios.mockResponse('get', {
        data: { attributes: {
          "is_valid": false,
        } }
      })

      defaultWrapper.vm.email = 'invalid'
      defaultWrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(defaultWrapper.vm.emailIsValid).toBe(false)
        done()
      })
    })

    it('detects temporary email', (done) => {
      axios.mockResponse('get', {
        data: { attributes: {
          "is_disposable_address": true,
        } }
      })

      defaultWrapper.vm.email = 'something@disposable.com'
      defaultWrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(defaultWrapper.vm.isDisposableAddress).toBe(true)
        done()
      })
    })

    it('detects a "did you mean...?" suggestion', (done) => {
      axios.mockResponse('get', {
        data: { attributes: {
          "did_you_mean": "joe@gmail.com",
        } }
      })

      defaultWrapper.vm.email = 'joe@gmil.com'
      defaultWrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(defaultWrapper.vm.didYouMean).toEqual("joe@gmail.com")
        done()
      })
    })

    it('detects a mailbox_verification', (done) => {
      axios.mockResponse('get', {
        data: { attributes: {
          "mailbox_verification": true,
        } }
      })

      defaultWrapper.vm.email = 'exists@gmail.com'
      defaultWrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(defaultWrapper.vm.mailboxVerification).toBe(true)
        done()
      })
    })

    it('detects a failed mailbox_verification', (done) => {
      axios.mockResponse('get', {
        data: { attributes: {
          "mailbox_verification": false,
        } }
      })

      defaultWrapper.vm.email = 'missing@gmail.com'
      defaultWrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(defaultWrapper.vm.mailboxVerification).toBe(false)
        done()
      })
    })

    it('detects a duplicate email', (done) => {
      axios.mockResponse('get', {
        data: { attributes: {
          "is_taken": true,
        } }
      })

      defaultWrapper.vm.email = 'taken@gmail.com'
      defaultWrapper.vm.validateEmailInput()

      setImmediate(() => {
        expect(defaultWrapper.vm.emailIsTaken).toBe(true)
        done()
      })
    })
  })
})