import { shallowMount } from '@vue/test-utils'

import Registration from 'admin/content-settings/components/Registration'

describe('Admin Content & Settings - Registration component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(Registration)
  })

  it('has a name attribute', () => {
    expect(Registration.name).toEqual('registration-section')
  })

})