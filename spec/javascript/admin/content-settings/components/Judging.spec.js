import { shallowMount } from '@vue/test-utils'

import Judging from 'admin/content-settings/components/Judging'

describe('Admin Content & Settings - Judging component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(Judging)
  })

  it('has a name attribute', () => {
    expect(Judging.name).toEqual('judging-section')
  })

})