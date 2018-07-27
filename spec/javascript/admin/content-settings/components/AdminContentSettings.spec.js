import Vuex from 'vuex'
import { shallowMount, createLocalVue, RouterLinkStub } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import AdminContentSettings from 'admin/content-settings/components/AdminContentSettings'
import Icon from 'components/Icon'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - AdminContentSettings component', () => {

  let wrapper

  function assertIconProps(icon) {
    expect(icon.props()).toEqual(
      expect.objectContaining({
        name: 'exclamation-circle',
        size: 16,
        color: 'D8000C',
      })
    )
  }

  beforeEach(() => {
    wrapper = shallowMount(
      AdminContentSettings,
      {
        localVue,
        store: mockStore.createMocks().store,
        stubs: {
          RouterLink: RouterLinkStub,
          'router-view': true,
        },
      }
    )
  })

  it('has a name attribute', () => {
    expect(AdminContentSettings.name).toEqual('admin-content-settings')
  })

  describe('HTML layout', () => {

    it('contains the tab grid layout', () => {
      expect(wrapper.find('#admin-content-settings').classes()).toEqual([
        'tabs',
        'tabs--vertical',
        'grid',
      ])

      expect(wrapper.find('#admin-content-settings ul').classes()).toEqual([
        'tabs__menu',
        'grid__col-md-3',
      ])

      expect(wrapper.find('router-view-stub').classes()).toEqual([
        'tabs__content',
        'grid__col-md-9',
      ])

      const routerLinks = wrapper.findAll(RouterLinkStub).wrappers

      routerLinks.forEach((link) => {
        const props = link.props()
        const attributes = link.attributes()

        expect(props.tag).toBe('li')
        expect(props.activeClass).toBe('tabs__menu-link--active')
        expect(attributes.class).toBe('tabs__menu-link')

        expect(link.find('button[role="button"]').classes()).toEqual([
          'tabs__menu-button',
        ])
      })
    })

    it('displays warning icons on router links if judging is enabled', () => {
      wrapper = shallowMount(
        AdminContentSettings,
        {
          localVue,
          store: mockStore
            .createMocks({
              getters: {
                judgingEnabled: () => {
                  return true
                },
              },
            })
            .store,
          stubs: {
            RouterLink: RouterLinkStub,
            'router-view': true,
          },
        }
      )

      expect(wrapper.vm.judgingEnabled).toBe(true)

      const registrationLink = wrapper.find({ ref: 'registrationLink' })
      assertIconProps(registrationLink.find(Icon))

      const noticesLink = wrapper.find({ ref: 'noticesLink' })
      expect(noticesLink.find(Icon).exists()).toBe(false)

      const surveysLink = wrapper.find({ ref: 'surveysLink' })
      expect(surveysLink.find(Icon).exists()).toBe(false)

      const teamsAndSubmissionsLink = wrapper
        .find({ ref: 'teamsAndSubmissionsLink' })
      assertIconProps(teamsAndSubmissionsLink.find(Icon))

      const eventsLink = wrapper.find({ ref: 'eventsLink' })
      assertIconProps(eventsLink.find(Icon))

      const judgingLink = wrapper.find({ ref: 'judgingLink' })
      expect(judgingLink.find(Icon).exists()).toBe(false)

      const scoresAndCertificatesLink = wrapper
        .find({ ref: 'scoresAndCertificatesLink' })
      assertIconProps(scoresAndCertificatesLink.find(Icon))
    })

  })

})