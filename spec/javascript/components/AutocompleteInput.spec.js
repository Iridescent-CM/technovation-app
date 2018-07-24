import { shallowMount, mount } from '@vue/test-utils'
import axios from 'axios'
import VueSelect from 'vue-select'

import AutocompleteInput from 'components/AutocompleteInput'

describe('AutocompleteInput Vue component', () => {

  let wrapper

  function propsData(propsToMerge = {}) {
    const propsData = {
      name: 'this_is_the_input_name',
      id: 'this_is_the_input_id',
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

  it('contains the vue-select component', () => {
    expect(AutocompleteInput.components).toEqual({
      VueSelect,
    })
  })

  describe('props', () => {

    it('contains valid props', () => {
      expect(AutocompleteInput.props).toEqual({
        id: {
          type: String,
          default: '',
        },

        name: {
          type: String,
          default: '',
        },

        noOptionsText: {
          type: String,
          default: '',
        },

        options: {
          type: Array,
          default: expect.any(Function),
        },

        url: {
          type: String,
          default: '',
        },

        value: {
          type: String,
          default: '',
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
        mutableValue: null,
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

    it('populates mutableValue from value prop if supplied', (done) => {
      wrapper = shallowMount(AutocompleteInput, {
        propsData: propsData({
          value: 'Hello',
        }),
        attachToDocument: true,
      })

      wrapper.vm.$nextTick(() => {
        expect(wrapper.vm.mutableValue).toEqual('Hello')
        done()
      })
    })

    it('sets mutableValue to null if value prop is not supplied', (done) => {
      wrapper.vm.$nextTick(() => {
        expect(wrapper.vm.mutableValue).toEqual(null)
        done()
      })
    })

  })

  describe('watchers', () => {

    describe('value', () => {

      it('sets the mutableValue if new value is a valid string input', (done) => {
        wrapper.setProps({
          value: 'New',
        })

        wrapper.vm.$nextTick(() => {
          expect(wrapper.vm.mutableValue).toEqual('New')
          done()
        })
      })

      it('sets the mutableValue to null if new value is null', (done) => {
        wrapper.setProps({
          value: null,
        })

        wrapper.vm.$nextTick(() => {
          expect(wrapper.vm.mutableValue).toEqual(null)
          done()
        })
      })

      it('sets the mutableValue to null if new value is empty string', (done) => {
        wrapper.setProps({
          value: '',
        })

        wrapper.vm.$nextTick(() => {
          expect(wrapper.vm.mutableValue).toEqual(null)
          done()
        })
      })
    })

  })

  describe('markup and interactions', () => {

    beforeEach(() => {
      wrapper = mount(AutocompleteInput, {
        propsData: propsData(),
        attachToDocument: true,
      })
    })

    it('initializes a hidden input to store the value for submission', (done) => {
      wrapper.setProps({
        value: 'Bam!',
      })

      wrapper.vm.$nextTick(() => {
        const inputAttributes = wrapper.find({ ref: 'valueInput' }).attributes()

        expect(inputAttributes.type).toEqual('hidden')
        expect(inputAttributes.name).toEqual(wrapper.vm.name)
        expect(inputAttributes.value).toEqual(wrapper.vm.mutableValue)
        expect(inputAttributes.value).toEqual('Bam!')
        done()
      })
    })

    it('initializes the vue-select with the required properties', (done) => {
      wrapper.setProps({
        value: 'Howdy',
      })

      wrapper.vm.$nextTick(() => {
        const vueSelectProps = wrapper.find(VueSelect).props()

        expect(vueSelectProps.inputId).toEqual(wrapper.vm.id)
        expect(vueSelectProps.options).toEqual(wrapper.vm.mutableOptions)
        expect(vueSelectProps.value).toEqual('Howdy')
        expect(vueSelectProps.taggable).toBe(true)
        done()
      })
    })

  })

})