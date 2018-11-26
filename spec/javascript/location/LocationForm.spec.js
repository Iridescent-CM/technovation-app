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

  describe('optional label for the state/region selection field label', () => {
    function mockAxiosForCountry(country) {
      const countryName = encodeURIComponent(country)

      axios.get.mockClear()

      axios.get.mockImplementation((url) => {
        if (url === '/student/current_location') {
          return Promise.resolve({
            data: {
              country,
              city: 'City',
              state: '',
            },
            status: 200,
          })
        } else if (url === '/public/countries') {
          return Promise.resolve({
            data: countries,
            status: 200,
          })
        } else if (url === `/public/countries?name=${countryName}`) {
          return Promise.resolve({
            data: [],
            status: 200,
          })
        }
      })
    }

    it('displays for Hong Kong', (done) => {
      mockAxiosForCountry('Hong Kong')

      const wrapper = shallowMount(LocationForm, {
        propsData: {
          scopeName: 'student',
        },
      })

      setImmediate(() => {
        expect(wrapper.find('label[for="location_state"]').text()).toEqual('State / Province (Optional)')
        done()
      })
    })

    it('displays for India', (done) => {
      mockAxiosForCountry('India')

      const wrapper = shallowMount(LocationForm, {
        propsData: {
          scopeName: 'student',
        },
      })

      setImmediate(() => {
        expect(wrapper.find('label[for="location_state"]').text()).toEqual('State / Province (Optional)')
        done()
      })
    })

    it('displays for Palestine', (done) => {
      mockAxiosForCountry('Palestine')

      const wrapper = shallowMount(LocationForm, {
        propsData: {
          scopeName: 'student',
        },
      })

      setImmediate(() => {
        expect(wrapper.find('label[for="location_state"]').text()).toEqual('State / Province (Optional)')
        done()
      })
    })

    it('displays for Taiwan', (done) => {
      mockAxiosForCountry('Taiwan')

      const wrapper = shallowMount(LocationForm, {
        propsData: {
          scopeName: 'student',
        },
      })

      setImmediate(() => {
        expect(wrapper.find('label[for="location_state"]').text()).toEqual('State / Province (Optional)')
        done()
      })
    })

    it('is hidden for United States', (done) => {
      mockAxiosForCountry('United States')

      const wrapper = shallowMount(LocationForm, {
        propsData: {
          scopeName: 'student',
        },
      })

      setImmediate(() => {
        expect(wrapper.find('label[for="location_state"]').text()).toEqual('State / Province')
        done()
      })
    })
  })

  describe('handleSubmit', () => {
    const scopes = [
      'admin',
      'judge',
      'mentor',
      'registration',
      'student',
    ]

    beforeEach(() => {
      axios.post.mockClear()
      axios.mockResponseOnce('post', {})
    })

    scopes.forEach((scope) => {
      describe(`for ${scope} scope`, () => {
        const accountId = 1
        const teamId = 1

        it(`sends a POST request to /${scope}/location by default`, (done) => {
          const wrapper = shallowMount(LocationForm, {
            propsData: {
              scopeName: scope,
              value: {
                country: 'United States',
                state: 'Illinois',
                city: 'Chicago',
              },
              wizardToken: '1234567',
            },
          })

          setImmediate(() => {
            wrapper.vm.handleSubmit()
            expect(axios.post).toHaveBeenCalledWith(
              `/${scope}/location`,
              {
                [`${scope}_location`]: {
                  city: 'Chicago',
                  country: 'United States',
                  state: 'Illinois',
                  token: '1234567',
                },
              }
            )
            done()
          })
        })

        it(`sends a POST request to /${scope}/location?account_id=${accountId} when account ID prop is present`, (done) => {
          const wrapper = shallowMount(LocationForm, {
            propsData: {
              accountId,
              scopeName: scope,
              value: {
                country: 'United States',
                state: 'Illinois',
                city: 'Chicago',
              },
              wizardToken: '1234567',
            },
          })

          setImmediate(() => {
            wrapper.vm.handleSubmit()
            expect(axios.post).toHaveBeenCalledWith(
              `/${scope}/location?account_id=${accountId}`,
              {
                [`${scope}_location`]: {
                  city: 'Chicago',
                  country: 'United States',
                  state: 'Illinois',
                  token: '1234567',
                },
              }
            )
            done()
          })
        })

        it(`sends a POST request to /${scope}/location?team_id=${teamId} when account ID prop is present`, (done) => {
          const wrapper = shallowMount(LocationForm, {
            propsData: {
              teamId,
              scopeName: scope,
              value: {
                country: 'United States',
                state: 'Illinois',
                city: 'Chicago',
              },
              wizardToken: '1234567',
            },
          })

          setImmediate(() => {
            wrapper.vm.handleSubmit()
            expect(axios.post).toHaveBeenCalledWith(
              `/${scope}/location?team_id=${teamId}`,
              {
                [`${scope}_location`]: {
                  city: 'Chicago',
                  country: 'United States',
                  state: 'Illinois',
                  token: '1234567',
                },
              }
            )
            done()
          })
        })
      })
    })
  })
})