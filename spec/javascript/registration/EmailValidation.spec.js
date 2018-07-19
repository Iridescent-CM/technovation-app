import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import EmailValidation from 'registration/components/EmailValidation'

describe('EmailValidation Vue component', () => {
  it('mounts', () => {
    const wrapper = shallowMount(EmailValidation)
    expect(wrapper).toBeDefined()
  })
})