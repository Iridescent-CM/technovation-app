import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import LocationForm from 'location/components/LocationForm'

describe('location/components/LocationForm', () => {
  const countries = [
    'Canada',
    'Hong Kong',
    'India',
    'Mexico',
    'Palestine',
    'Taiwan',
    'United States',
  ]

  beforeEach(() => {
    axios.get.mockClear()

    axios.get.mockImplementation((url) => {
      if (url === '/student/current_location') {
        return Promise.resolve({
          data: {
            city: 'Chicago',
            state: 'Illinois',
            country: 'United States',
          },
          status: 200,
        })
      } else if (url === '/public/countries') {
        return Promise.resolve({
          data: countries,
          status: 200,
        })
      } else if (url === '/public/countries?name=United%20States') {
        return Promise.resolve({
          data: [
            'California',
            'Illinois',
            'Missouri',
          ],
          status: 200,
        })
      }

      return Promise.resolve({
        data: {},
        status: 200,
      })
    })
  })

  it('fills in the user location data from the server', (done) => {
    const wrapper = shallowMount(LocationForm, {
      propsData: {
        scopeName: 'student',
      },
    })

    setImmediate(() => {
      // Should populate the current location via AJAX
      expect(axios.get).toHaveBeenCalledWith('/student/current_location')

      expect(wrapper.vm.city).toEqual('Chicago')
      expect(wrapper.vm.state).toEqual('Illinois')
      expect(wrapper.vm.country).toEqual('United States')

      expect(wrapper.find({ ref: 'cityField' }).element.value).toEqual('Chicago')
      expect(wrapper.find({ ref: 'stateField' }).vm.value).toEqual('Illinois')
      expect(wrapper.find({ ref: 'countryField' }).vm.value).toEqual('United States')

      // Should populate the country drop-down
      expect(axios.get).toHaveBeenCalledWith('/public/countries')

      expect(wrapper.vm.countries).toEqual(countries)

      // Populating the countries will trigger a watcher update that populates subregions
      expect(axios.get).toHaveBeenCalledWith('/public/countries?name=United%20States')

      expect(wrapper.vm.subregions).toEqual([
        'California',
        'Illinois',
        'Missouri',
      ])

      done()
    })
  })

  it('accepts an optional accountId prop for the current location request', (done) => {
    shallowMount(LocationForm, {
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