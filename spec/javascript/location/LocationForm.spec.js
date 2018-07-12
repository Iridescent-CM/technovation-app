import { shallowMount, createLocalVue } from '@vue/test-utils'
import axios from 'axios'

import LocationForm from 'location/components/LocationForm'

const localVue = createLocalVue()

describe('location/components/LocationForm', () => {
  let wrapper

  beforeEach(() => {
    axios.get.mockClear()

    wrapper = shallowMount(LocationForm, {
      localVue,
      propsData: {
        scopeName: "student",
      },
    })
  })

  it('mounts with city, state, country input fields', () => {
    expect(wrapper.contains('input[type=text]#location_city')).toBe(true)
    expect(wrapper.contains('input[type=text]#location_state')).toBe(true)
    expect(wrapper.contains('select#location_country')).toBe(true)
  })

  it('fills in the user location data from the server', (done) => {
    axios.mockResponseOnce('get', {
      city: "Chicago",
      state_code: "IL",
      country_code: "US",
    })

    const myWrapper = shallowMount(LocationForm, {
      localVue,
      propsData: {
        scopeName: "student",
      },
    })

    setImmediate(() => {
      expect(axios.get).toHaveBeenCalledWith('/student/current_location')
      expect(myWrapper.vm.city).toEqual("Chicago")
      expect(myWrapper.vm.state_code).toEqual("IL")
      expect(myWrapper.vm.country_code).toEqual("US")
      done()
    })
  })
})