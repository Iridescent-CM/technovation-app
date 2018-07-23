import { shallowMount, RouterLinkStub } from '@vue/test-utils'

import AdminContentSettings from 'admin/content-settings/components/AdminContentSettings'

describe('Admin Content & Settings - AdminContentSettings component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      AdminContentSettings, {
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

  })

})