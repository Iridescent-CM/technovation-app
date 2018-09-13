import { shallowMount } from '@vue/test-utils'

import Tabs from 'components/Tabs'

describe('Tabs Vue component', () => {
  // Set a template for the component to prevent console errors.
  // This can also be used to test DOM behaviors should that be desired.
  // Or simplified if not: Tabs.template='<div></div>'
  Tabs.template = `
    <div id="tabs-app">
      <ul class="tabs_menu">
        <li
          class="tabs__menu-link"
          :class="{
            'tabs__menu-link--active': isSection('students')
          }"
        >
          <button
            role="button"
            class="tabs__menu-button"
            @click.stop.prevent="setSection('students')"
          >
            Students
          </button>
        </li>

        <li
          class="tabs__menu-link"
          :class="{
            'tabs__menu-link--active': isSection('mentors')
          }"
        >
          <button
            role="button"
            class="tabs__menu-button"
            @click.stop.prevent="setSection('mentors')"
          >
            Mentors
          </button>
        </li>
      </ul>

      <div class="tabs__content">
        <div class="tabs__tab-content" v-show="isSection('students')">
          <h1 class="content-heading">Students</h1>
        </div>

        <div class="tabs__tab-content" v-show="isSection('mentors')">
          <h1 class="content-heading">Mentors</h1>
        </div>
      </div>
    </div>
  `

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(Tabs, {
      propsData: {
        section: 'students',
      },
    })
  })

  describe('props', () => {
    it('contains a valid list of props', () => {
      expect(Tabs.props).toEqual({
        section: {
          type: String,
          default: '',
        }
      })
    })
  })

  describe('data', () => {
    it('contains correct initial data state', () => {
      expect(Tabs.data()).toEqual({
        mutableSection: '',
      })
    })
  })

  describe('created hook', () => {
    it('sets the current section', () => {
      wrapper.destroy()

      const historyState = history.state
      const historySpy = spyOn(history, 'replaceState').and.callThrough()

      expect(historySpy).not.toHaveBeenCalled()

      wrapper = shallowMount(Tabs, {
        propsData: {
          section: 'mentors',
        },
      })

      expect(wrapper.vm.mutableSection).toEqual('mentors')
      expect(historySpy)
        .toHaveBeenCalledWith(historyState, '', `#!mentors`)
    })
  })

  describe('methods', () => {
    describe('isSection', () => {
      it('returns true if section parameter matches the current section', () => {
        const result = wrapper.vm.isSection('students')
        expect(result).toBe(true)
      })

      it('returns false if section parameter does not match the current section', () => {
        const result = wrapper.vm.isSection('mentors')
        expect(result).toBe(false)
      })
    })

    describe('setSection', () => {
      it('sets the current section', () => {
        const historyState = history.state
        const historySpy = spyOn(history, 'replaceState').and.callThrough()

        expect(historySpy).not.toHaveBeenCalled()

        wrapper.vm.setSection('mentors')

        expect(wrapper.vm.mutableSection).toEqual('mentors')
        expect(historySpy)
          .toHaveBeenCalledWith(historyState, '', `#!mentors`)
      })
    })
  })
})
