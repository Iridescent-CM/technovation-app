import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import AutocompleteInput from 'components/AutocompleteInput'

describe('AutocompleteInput Vue component', () => {

  let wrapper

  function propsData(propsToMerge = {}) {
    const propsData = {
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
    }

    return Object.assign({}, propsData, propsToMerge)
  }


  beforeEach(() => {
    wrapper = shallowMount(AutocompleteInput, {
      propsData: propsData(),
      attachToDocument: true,
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
        mutableOptions: [],
      })
    })

  })

  describe('created hook', () => {

    beforeEach(() => {
      axios.mockResponseOnce('get', {
        attributes: [
          'Rock',
          'Paper',
          'Scissors',
        ],
      })
    })

    it('populates mutableOptions via AJAX if url prop is supplied', (done) => {
      wrapper = shallowMount(AutocompleteInput, {
        propsData: propsData({
          url: '/test/url',
        }),
        attachToDocument: true,
      })

      setImmediate(() => {
        expect(wrapper.vm.mutableOptions).toEqual([
          'Rock',
          'Paper',
          'Scissors',
        ])
        done()
      })
    })

    it('populates mutableOptions from options prop if url is not supplied', (done) => {
      wrapper = shallowMount(AutocompleteInput, {
        propsData: propsData({
          url: '',
        }),
        attachToDocument: true,
      })

      wrapper.vm.$nextTick(() => {
        expect(wrapper.vm.mutableOptions).toEqual([
          'Apple',
          'Orange',
          'Grape',
          'Gravy',
          'Strawberry',
        ])
        done()
      })
    })

    it('creates debounced getSuggestions function', () => {
      jest.useFakeTimers()

      const testFunction = jest.fn(() => {})
      const getSuggestionsSpy = spyOn(wrapper.vm, 'getSuggestions')

      expect(getSuggestionsSpy).not.toHaveBeenCalled()

      wrapper.vm.getSuggestionsDebounced('Test', testFunction)

      jest.advanceTimersByTime(150)

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

      it('makes filtered suggestions from mutableOptions', () => {
        const testFunction = jest.fn(() => {})

        wrapper.vm.getSuggestions('GRA', testFunction)

        expect(testFunction).toHaveBeenCalledWith([
          'Grape',
          'Gravy',
        ])
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