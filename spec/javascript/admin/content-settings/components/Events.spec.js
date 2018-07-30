import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Events from 'admin/content-settings/components/Events'
import Icon from 'components/Icon'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Events component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Events,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Events.name).toEqual('events-section')
  })

  describe('markup', () => {

    it('contains the proper HTML based on data', () => {
      const selectRegionalPitchEventCheckbox = wrapper
        .find('#season_toggles_select_regional_pitch_event')
      const selectRegionalPitchEventCheckboxLabel = wrapper
        .find('label[for="season_toggles_select_regional_pitch_event"]')

      expect(wrapper.vm.judgingEnabled).toBe(false)

      expect(selectRegionalPitchEventCheckbox.exists()).toBe(true)
      expect(selectRegionalPitchEventCheckboxLabel.exists()).toBe(true)
    })

    it('disables checkboxes and sets values to 0 is judging is enabled', () => {
      wrapper = shallowMount(
        Events,
        {
          localVue,
          store: mockStore.createMocks({
            getters: {
              judgingEnabled: () => {
                return true
              },
            },
          }).store,
        }
      )

      const selectRegionalPitchEventCheckbox = wrapper
        .find('#season_toggles_select_regional_pitch_event')
      const selectRegionalPitchEventCheckboxLabel = wrapper
        .find('label[for="season_toggles_select_regional_pitch_event"]')

      expect(wrapper.vm.judgingEnabled).toBe(true)

      expect(selectRegionalPitchEventCheckbox.attributes()).toEqual(
        expect.objectContaining({
          id: 'season_toggles_select_regional_pitch_event',
          type: 'checkbox',
          disabled: 'disabled',
          value: '0',
        })
      )

      expect(selectRegionalPitchEventCheckboxLabel.attributes()).toEqual(
        expect.objectContaining({
          class: 'label--disabled',
        })
      )
    })

    it('displays warning notices if judging is enabled', () => {
      wrapper = shallowMount(
        Events,
        {
          localVue,
          store: mockStore.createMocks({
            getters: {
              judgingEnabled: () => {
                return true
              },
            },
          }).store,
        }
      )

      expect(wrapper.vm.judgingEnabled).toBe(true)

      const notice = wrapper.find('.notice')

      expect(notice.exists()).toBe(true)

      const props = notice.find(Icon).props()

      expect(props).toEqual(
        expect.objectContaining({
          name: 'exclamation-circle',
          size: 16,
          color: '00529B',
        })
      )
    })

  })

})