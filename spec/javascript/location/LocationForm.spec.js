import { shallowMount, createLocalVue } from '@vue/test-utils'
import axios from 'axios'

import LocationResult from 'location/models/LocationResult'
import LocationForm from 'location/components/LocationForm'

const localVue = createLocalVue()

describe('location/components/LocationForm', () => {
  beforeEach(() => {
    axios.get.mockClear()
  })

  xit('fills in the user location data from the server', (done) => {
    axios.mockResponseOnce('get', {
      city: 'Chicago',
      state: 'IL',
      country: 'US',
    })

    const myWrapper = shallowMount(LocationForm, {
      localVue,
      propsData: {
        scopeName: 'student',
      },
    })

    setImmediate(() => {
      expect(axios.get).toHaveBeenCalledWith('/student/current_location')

      expect(myWrapper.vm.city).toEqual('Chicago')
      expect(myWrapper.vm.state).toEqual('IL')
      expect(myWrapper.vm.country).toEqual('US')

      expect(myWrapper.find('#location_city').element.value).toEqual('Chicago')
      expect(myWrapper.find({ ref: 'stateField'}).$data.value).toEqual('IL')
      done()
    })
  })

  it('accepts an optional accountId prop for the current location request', (done) => {
    shallowMount(LocationForm, {
      localVue,
      propsData: {
        accountId: 1,
        scopeName: 'admin',
      },
    })

    setImmediate(() => {
      expect(axios.get).toHaveBeenCalledWith('/admin/current_location?account_id=1')
      done()
    })
  })

  it('accepts an optional teamId prop for the current location request', (done) => {
    shallowMount(LocationForm, {
      localVue,
      propsData: {
        teamId: 1,
        scopeName: 'admin',
      },
    })

    setImmediate(() => {
      expect(axios.get).toHaveBeenCalledWith('/admin/current_location?team_id=1')
      done()
    })
  })

  describe('full integration suite for single result', () => {
    const suggestionsResults = [
      {
        id: 'd7070f84',
        state_code: 'MO',
        state: 'Missouri',
        latitude: 39.0997265,
        longitude: -94.5785667,
        city: 'Kansas City',
        country_code: 'US',
        country: 'United States'
      },
    ]

    let wrapper

    beforeEach(() => {
      axios.get.mockClear()
      axios.post.mockClear()
      axios.patch.mockClear()
    })

    it('it makes a GET request to populate the initial location', () => {
      axios.mockResponseOnce('get', {
        city: 'Chicago',
        state: 'IL',
        country: 'US',
      })

      expect(axios.get).not.toHaveBeenCalled()

      wrapper = shallowMount(LocationForm, {
        localVue,
        propsData: {
          teamId: 1,
          scopeName: 'student',
          handleConfirm: jest.fn(() => {}),
        },
      })

      expect(axios.get).toHaveBeenCalledWith('/student/current_location?team_id=1')
    })

    it('saved the final saved location to the database via another XHR request', (done) => {
      axios.mockResponseOnce('post', {})

      const handleConfirmSpy = jest.spyOn(wrapper.vm, 'handleConfirm')

      expect(axios.post).not.toHaveBeenCalled()

      wrapper.vm.handleSubmit()

      expect(axios.post).toHaveBeenCalledWith(
        wrapper.vm.patchLocationEndpoint,
        wrapper.vm.params
      )

      setImmediate(() => {
        expect(handleConfirmSpy).toHaveBeenCalledTimes(1)
        done()
      })
    })
  })
})