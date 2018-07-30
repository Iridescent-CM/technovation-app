import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import ScoresAndCertificates from 'admin/content-settings/components/ScoresAndCertificates'
import Icon from 'components/Icon'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - ScoresAndCertificates component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      ScoresAndCertificates,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(ScoresAndCertificates.name).toEqual('scores-and-certificates-section')
  })

  describe('markup', () => {

    it('contains the proper HTML based on data', () => {
      const displayScoresCheckbox = wrapper.find('#season_toggles_display_scores')
      const displayScoresCheckboxLabel = wrapper
        .find('label[for="season_toggles_display_scores"]')

      expect(wrapper.vm.judgingEnabled).toBe(false)

      expect(displayScoresCheckbox.exists()).toBe(true)
      expect(displayScoresCheckboxLabel.exists()).toBe(true)
    })

    it('disables checkboxes and sets values to 0 is judging is enabled', () => {
      wrapper = shallowMount(
        ScoresAndCertificates,
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

      const displayScoresCheckbox = wrapper.find('#season_toggles_display_scores')
      const displayScoresCheckboxLabel = wrapper
        .find('label[for="season_toggles_display_scores"]')

      expect(wrapper.vm.judgingEnabled).toBe(true)

      expect(displayScoresCheckbox.attributes()).toEqual(
        expect.objectContaining({
          id: 'season_toggles_display_scores',
          type: 'checkbox',
          disabled: 'disabled',
          value: '0',
        })
      )

      expect(displayScoresCheckboxLabel.attributes()).toEqual(
        expect.objectContaining({
          class: 'label--disabled',
        })
      )
    })

    it('displays warning notices if judging is enabled', () => {
      wrapper = shallowMount(
        ScoresAndCertificates,
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