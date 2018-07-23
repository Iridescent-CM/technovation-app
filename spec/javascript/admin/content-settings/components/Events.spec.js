import { shallowMount } from '@vue/test-utils'

import Events from 'admin/content-settings/components/Events'

describe('Admin Content & Settings - Events component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(Events)
  })

  it('has a name attribute', () => {
    expect(Events.name).toEqual('events-section')
  })

})