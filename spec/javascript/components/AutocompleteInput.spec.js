import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import AutocompleteInput from 'components/AutocompleteInput'

describe('AutocompleteInput Vue component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(AutocompleteInput, {
      attachToDocument: true,
      propsData: {
        name: 'input_name',
        id: 'input_id',
        url: '',
        options: [
          'Apple',
          'Orange',
          'Grape',
          'Gravy',
          'Strawberry',
        ],
      },
    })

    axios.get.mockClear()
  })

  it('has the correct name', () => {
    expect(AutocompleteInput.name).toEqual('autocomplete-input')
  })

  describe('props', () => {

    it('contains valid props', () => {
      expect(AutocompleteInput.props).toEqual({
        name: {
          type: String,
          default: '',
        },

        id: {
          type: String,
          default: '',
        },

        url: {
          type: String,
          default: '',
        },

        options: {
          type: Array,
          default: expect.any(Function),
        },
      })
    })

    describe('options', () => {

      it('is an empty Array by default', () => {
        expect(AutocompleteInput.props.options.default()).toEqual([])
      })

    })

  })

  describe('data', () => {

    it('sets the correct initial state', () => {
      expect(AutocompleteInput.data()).toEqual({
        autoCompleteInstance: null,
      })
    })

  })

  describe('created hook', () => {

    it('creates debounced getSuggestions function', () => {
      jest.useFakeTimers()

      const testFunction = jest.fn(() => {})
      const getSuggestionsSpy = spyOn(wrapper.vm, 'getSuggestions')

      expect(getSuggestionsSpy).not.toHaveBeenCalled()

      wrapper.vm.getSuggestionsDebounced('Test', testFunction)

      jest.advanceTimersByTime(400)

      expect(getSuggestionsSpy).not.toHaveBeenCalled()

      jest.advanceTimersByTime(101)

      expect(getSuggestionsSpy).toHaveBeenCalledWith('Test', testFunction)
    })

  })

  describe('mounted hook', () => {

    it('initializes autoCompleteInstance using autoComplete', () => {
      expect(wrapper.vm.autoCompleteInstance).not.toBe(null)
      expect(wrapper.vm.autoCompleteInstance.destroy)
        .toEqual(expect.any(Function))
    })

  })

  describe('methods', () => {

    describe('initializeAutocomplete', () => {

      it('destroys the autoCompleteInstance if already initialized', () => {
        const destroySpy = spyOn(wrapper.vm.autoCompleteInstance, 'destroy')

        wrapper.vm.initializeAutocomplete()

        expect(destroySpy).toHaveBeenCalledTimes(1)
      })

      it('initializes the autoComplete widget on the input', () => {
        wrapper.vm.autoCompleteInstance.destroy()
        wrapper.vm.autoCompleteInstance = null

        wrapper.vm.initializeAutocomplete()

        expect(wrapper.vm.autoCompleteInstance).not.toEqual(null)
        expect(wrapper.vm.autoCompleteInstance.destroy)
          .toEqual(expect.any(Function))
      })

    })

    describe('getSuggestions', () => {

      beforeEach(() => {
        axios.mockResponseOnce('get', {
          attributes: [
            'Grape',
            'Gravy',
          ],
        })
      })

      it('makes GET request to fetch suggestions and uses them with callback ' +
        'if url prop is not empty', (done) => {
          const testFunction = jest.fn(() => {})

          wrapper.setProps({
            url: '/test/url',
          })

          wrapper.vm.getSuggestions('GRA', testFunction)

          wrapper.vm.$nextTick(() => {
            expect(axios.get).toHaveBeenCalledWith(
              '/test/url',
              {
                params: {
                  q: 'gra',
                },
              }
            )

            expect(testFunction).toHaveBeenCalledTimes(1)
            expect(testFunction).toHaveBeenCalledWith([
              'Grape',
              'Gravy',
            ])
            done()
          })
      })

      it('makes suggestions from options prop if url prop is not empty', (done) => {
          const testFunction = jest.fn(() => {})

          wrapper.vm.getSuggestions('GRA', testFunction)

          wrapper.vm.$nextTick(() => {
            expect(axios.get).not.toHaveBeenCalled()

            expect(testFunction).toHaveBeenCalledTimes(1)
            expect(testFunction).toHaveBeenCalledWith([
              'Grape',
              'Gravy',
            ])
            done()
          })
      })
    })

  })

  describe('auto-complete functionality', () => {

    it('calls getSuggestionsDebounced for input on change', () => {
      jest.useFakeTimers()

      spyOn(wrapper.vm, 'getSuggestionsDebounced')

      const input = wrapper.find('input').element
      input.value = 'New value'

      input.dispatchEvent(
        new KeyboardEvent(
          'keyup',
          {
            keyCode: 25,
            which: 25,
          }
        )
      )

      jest.advanceTimersByTime(2000)

      expect(input.value).toEqual('New value')
      expect(wrapper.vm.getSuggestionsDebounced).toHaveBeenCalledTimes(1)
    })

  })

})