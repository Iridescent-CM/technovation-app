import { shallowMount, createLocalVue } from '@vue/test-utils'

import LocationForm from 'location/components/LocationForm'

const localVue = createLocalVue()

describe('location/components/LocationForm', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(LocationForm, { localVue })
  })

  it('mounts with city, state, country input fields', () => {
    expect(wrapper.contains('input[type=text]#location_city')).toBe(true)
    expect(wrapper.contains('input[type=text]#location_state')).toBe(true)
    expect(wrapper.contains('select#location_country')).toBe(true)
  })
})