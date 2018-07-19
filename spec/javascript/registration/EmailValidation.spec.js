import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import EmailValidation from 'registration/components/EmailValidation'

describe('EmailValidation Vue component', () => {
  it('mounts with an email field', () => {
    const wrapper = shallowMount(EmailValidation)
    wrapper.vm.email = 'joe@joesak.com'
    expect(wrapper.find('input[type=email]').element.value).toEqual('joe@joesak.com')
  })
})