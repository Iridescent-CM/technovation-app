import { shallowMount, createLocalVue } from '@vue/test-utils'
import axios from 'axios'

import LocationResult from 'location/models/LocationResult'
import LocationForm from 'location/components/LocationForm'

const localVue = createLocalVue()

describe('location/components/LocationForm', () => {
  beforeEach(() => {
    axios.get.mockClear()
  })

  it('fills in the user location data from the server', (done) => {
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
      expect(myWrapper.find('#location_state').element.value).toEqual('IL')
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

  describe('suggestions table', () => {
    let wrapper
    let handleSuggestionClickSpy

    beforeEach(() => {
      handleSuggestionClickSpy = jest.fn(() => {})

      wrapper = shallowMount(LocationForm, {
        localVue,
        propsData: {
          teamId: 1,
          scopeName: 'admin',
        },
        methods: {
          handleSuggestionClick: handleSuggestionClickSpy,
        },
      })

      wrapper.setData({
        suggestions: [
          { id: 1, city: 'Kansas City', state: 'Missouri', country: 'United States' },
          { id: 2, city: 'KC', state: 'MO', country: 'United States' },
          { id: 3, city: null, state: null, country: null },
        ],
      })
    })

    it('appears if there are suggestions present', () => {
      const suggestionsTable = wrapper.find({ ref: 'suggestionsTable' })

      expect(suggestionsTable.exists()).toBe(true)

      const suggestions = wrapper.findAll('.suggestion')

      expect(suggestions.length).toEqual(3)
    })

    it('is not visible if there are no suggestions present', async () => {
      wrapper.setData({ suggestions: [] })

      await wrapper.vm.$nextTick()

      const suggestionsTable = wrapper.find({ ref: 'suggestionsTable' })

      expect(suggestionsTable.exists()).toBe(false)

      const suggestions = wrapper.findAll('.suggestion')

      expect(suggestions.length).toEqual(0)
    })

    it('contains a row for each suggestion present', () => {
      const suggestions = wrapper.findAll('.suggestion')

      let suggestionText = suggestions.at(0).text()

      expect(suggestionText).toContain('Kansas City')
      expect(suggestionText).toContain('Missouri')
      expect(suggestionText).toContain('United States')

      suggestionText = suggestions.at(1).text()

      expect(suggestionText).toContain('KC')
      expect(suggestionText).toContain('MO')
      expect(suggestionText).toContain('United States')

      suggestionText = suggestions.at(2).text()

      expect(suggestionText).toContain('(no city)')
      expect(suggestionText).toContain('(no state/province)')
      expect(suggestionText).toContain('(no country)')
    })

    it('calls handleSuggestionClick when a suggestion row is clicked', () => {
      const suggestions = wrapper.findAll('.suggestion')

      suggestions.at(0).element.click()

      expect(handleSuggestionClickSpy).toHaveBeenCalledTimes(1)
      expect(handleSuggestionClickSpy).toHaveBeenCalledWith({
        id: 1,
        city: 'Kansas City',
        state: 'Missouri',
        country: 'United States',
      })

      suggestions.at(1).element.click()

      expect(handleSuggestionClickSpy).toHaveBeenCalledTimes(2)
      expect(handleSuggestionClickSpy).toHaveBeenCalledWith({
        id: 2,
        city: 'KC',
        state: 'MO',
        country: 'United States',
      })

      suggestions.at(2).element.click()

      expect(handleSuggestionClickSpy).toHaveBeenCalledTimes(3)
      expect(handleSuggestionClickSpy).toHaveBeenCalledWith({
        id: 3,
        city: null,
        state: null,
        country: null,
      })
    })
  })

  describe('saved locations table', () => {
    let wrapper

    beforeEach(() => {
      wrapper = shallowMount(LocationForm, {
        localVue,
        propsData: {
          teamId: 1,
          scopeName: 'admin',
        },
      })

      wrapper.setData({
        savedLocation: {
          id: 1,
          city: 'Kansas City',
          state: 'Missouri',
          country: 'United States'
        },
      })
    })

    it('appears if there is a saved location present', () => {
      const savedLocationTable = wrapper.find({ ref: 'savedLocationTable' })

      expect(savedLocationTable.exists()).toBe(true)

      const savedLocationText = wrapper.find({ ref: 'savedLocationTableRow' })
        .text()

      expect(savedLocationText).toContain('Kansas City')
      expect(savedLocationText).toContain('Missouri')
      expect(savedLocationText).toContain('United States')
    })

    it('is not visible if there is no saved location', async () => {
      wrapper.setData({ savedLocation: null })

      await wrapper.vm.$nextTick()

      const savedLocationTable = wrapper.find({ ref: 'savedLocationTable' })

      expect(savedLocationTable.exists()).toBe(false)

      const savedLocationRow = wrapper.find({ ref: 'savedLocationTableRow' })

      expect(savedLocationRow.exists()).toBe(false)
    })
  })

  describe('methods', () => {
    describe('handleSuggestionClick', () => {
      let wrapper
      let handleSubmitSpy
      const suggestion = {
        id: 1,
        city: 'Kansas City',
        state: 'Missouri',
        country: 'United States'
      }

      beforeEach(() => {
        handleSubmitSpy = jest.fn(() => {})

        wrapper = shallowMount(LocationForm, {
          localVue,
          propsData: {
            teamId: 1,
            scopeName: 'admin',
          },
          methods: {
            handleSubmit: handleSubmitSpy,
          },
        })
      })

      it('sets the city, state, and country information in the component data', () => {
        wrapper.vm.handleSuggestionClick(suggestion)

        expect(wrapper.vm.city).toEqual(suggestion.city)
        expect(wrapper.vm.state).toEqual(suggestion.state)
        expect(wrapper.vm.country).toEqual(suggestion.country)
        expect(wrapper.vm.countryConfirmed).toBe(true)
      })

      it('calls handleSubmit', () => {
        expect(handleSubmitSpy).not.toHaveBeenCalled()

        wrapper.vm.handleSuggestionClick(suggestion)

        expect(handleSubmitSpy).toHaveBeenCalledTimes(1)
      })
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

    it('sends a search request to the back-end using input data, returning one result', (done) => {
      axios.mockResponseOnce('patch', {
        results: suggestionsResults,
      })

      const handleOKResponseSpy = jest.spyOn(wrapper.vm, 'handleOKResponse')
      const handleErrorResponseSpy = jest.spyOn(wrapper.vm, 'handleErrorResponse')
      const suggestion = new LocationResult(suggestionsResults[0])

      expect(axios.patch).not.toHaveBeenCalled()

      wrapper.setData({
        city: 'Kansas City',
        state: 'Missouri',
        country: 'United States',
      })

      wrapper.vm.handleSubmit()

      expect(axios.patch).toHaveBeenCalledWith(
        wrapper.vm.patchLocationEndpoint,
        wrapper.vm.params
      )

      setImmediate(() => {
        expect(wrapper.vm.status).toEqual(200)

        expect(wrapper.vm.savedLocation).toEqual(suggestion)

        expect(wrapper.vm.city).toEqual(suggestion.city)
        expect(wrapper.vm.state).toEqual(suggestion.state)
        expect(wrapper.vm.country).toEqual(suggestion.country)
        expect(wrapper.vm.countryConfirmed).toBe(true)

        expect(wrapper.vm.suggestions.length).toEqual(0)

        expect(handleOKResponseSpy).toHaveBeenCalledTimes(1)
        expect(handleErrorResponseSpy).toHaveBeenCalledTimes(0)
        done()
      })
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
