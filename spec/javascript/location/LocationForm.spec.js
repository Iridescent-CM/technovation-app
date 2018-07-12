import { shallowMount, createLocalVue } from '@vue/test-utils'
import axios from 'axios'

import LocationForm from 'location/components/LocationForm'

const localVue = createLocalVue()

describe('location/components/LocationForm', () => {
  beforeEach(() => {
    axios.get.mockClear()
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
        countries: [["United States", "US"]],
      },
      methods: {
        initChosen () { },
      },
    })

    setImmediate(() => {
      expect(axios.get).toHaveBeenCalledWith('/student/current_location')

      expect(myWrapper.vm.city).toEqual("Chicago")
      expect(myWrapper.vm.stateCode).toEqual("IL")
      expect(myWrapper.vm.countryCode).toEqual("US")

      expect(myWrapper.find('#location_city').element.value).toEqual("Chicago")
      expect(myWrapper.find('#location_state').element.value).toEqual("IL")
      expect(myWrapper.find('#location_country').element.value).toEqual("US")
      done()
    })
  })

  it('accepts an optional accountId prop for the current location request', (done) => {
    shallowMount(LocationForm, {
      localVue,
      propsData: {
        accountId: 1,
        scopeName: "admin",
        countries: [["United States", "US"]],
      },
      methods: {
        initChosen () { },
      },
    })

    setImmediate(() => {
      expect(axios.get).toHaveBeenCalledWith('/admin/current_location?account_id=1')
      done()
    })
  })
})