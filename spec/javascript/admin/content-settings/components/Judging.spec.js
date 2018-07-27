import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Judging from 'admin/content-settings/components/Judging'
import Icon from 'components/Icon'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Judging component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Judging,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Judging.name).toEqual('judging-section')
  })

  describe('markup', () => {

    it('contains the proper HTML based on data', () => {
      const radioOff = wrapper.find('#season_toggles_judging_round_off')
      const radioOffLabel = wrapper
        .find('label[for="season_toggles_judging_round_off"]')
      const radioQuarterFinals = wrapper.find('#season_toggles_judging_round_qf')
      const radioQuarterFinalsLabel = wrapper
        .find('label[for="season_toggles_judging_round_qf"]')
      const radioSemiFinals = wrapper.find('#season_toggles_judging_round_sf')
      const radioSemiFinalsLabel = wrapper
        .find('label[for="season_toggles_judging_round_sf"]')

      expect(radioOff.attributes()).toEqual(
        expect.objectContaining({
          id: 'season_toggles_judging_round_off',
          type: 'radio',
          value: 'off',
        })
      )
      expect(radioOffLabel.exists()).toBe(true)

      expect(radioQuarterFinals.attributes()).toEqual(
        expect.objectContaining({
          id: 'season_toggles_judging_round_qf',
          type: 'radio',
          value: 'qf',
        })
      )
      expect(radioQuarterFinalsLabel.exists()).toBe(true)

      expect(radioSemiFinals.attributes()).toEqual(
        expect.objectContaining({
          id: 'season_toggles_judging_round_sf',
          type: 'radio',
          value: 'sf',
        })
      )
      expect(radioSemiFinalsLabel.exists()).toBe(true)
    })

    it('displays warning notice if judging is enabled', () => {
      wrapper = shallowMount(
        Judging,
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

      const notice = wrapper.find('.notice')
      const icon = notice.find(Icon)

      expect(wrapper.vm.judgingEnabled).toBe(true)
      expect(notice.exists()).toBe(true)
      expect(icon.exists()).toBe(true)
      expect(icon.props()).toEqual(
        expect.objectContaining({
          name: 'exclamation-circle',
          size: 16,
          color: '00529B',
        })
      )
    })

  })

})