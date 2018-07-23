import { shallowMount } from '@vue/test-utils'

import Notices from 'admin/content-settings/components/Notices'

describe('Admin Content & Settings - Notices component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(Notices)
  })

  it('has a name attribute', () => {
    expect(Notices.name).toEqual('notices-section')
  })

})