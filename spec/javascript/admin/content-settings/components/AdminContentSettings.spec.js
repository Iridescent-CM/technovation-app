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
        propsData: {
          cancelButtonUrl: '/admin/dashboard',
        },
      }
    )
  })

  it('has a name attribute', () => {
    expect(AdminContentSettings.name).toEqual('admin-content-settings')
  })

  describe('props', () => {

    it('contains the correct props', () => {
      expect(AdminContentSettings.props).toEqual({
        cancelButtonUrl: {
          type: String,
          required: true,
        },

        formData: {
          type: Object,
          default: expect.any(Function)
        }
      })
    })

    describe('formData', () => {

      it('returns an empty object by default', () => {
        expect(AdminContentSettings.props.formData.default()).toEqual({})
      })

    })

  })

  describe('created hook', () => {

    it('calls the mapped mutations in order to store the cancel URL and form data state', () => {
      const setCancelButtonUrl = jest.fn(() => {})
      const setFormData = jest.fn(() => {})

      expect(setCancelButtonUrl.mock.calls.length).toBe(0)
      expect(setFormData.mock.calls.length).toBe(0)

      wrapper = shallowMount(
        AdminContentSettings,
        {
          localVue,
          store: mockStore
            .createMocks({
              mutations: {
                setCancelButtonUrl,
                setFormData,
              },
            })
            .store,
          stubs: {
            RouterLink: RouterLinkStub,
            'router-view': true,
          },
          propsData: {
            cancelButtonUrl: '/admin/dashboard',
          },
        }
      )

      expect(setCancelButtonUrl.mock.calls.length).toBe(1)
      expect(setFormData.mock.calls.length).toBe(1)
    })

    it('applies the cancel button URL and form data props to the state', () => {
      wrapper = shallowMount(
        AdminContentSettings,
        {
          localVue,
          store: mockStore.createMocks().store,
          stubs: {
            RouterLink: RouterLinkStub,
            'router-view': true,
          },
          propsData: {
            formData: {
              student_signup: 1,
              student_dashboard_text: 'Student dashboard text',
              mentor_dashboard_text: 'Mentor dashboard text',
              judge_dashboard_text: 'Judge dashboard text',
              regional_ambassador_dashboard_text: 'RA dashboard text',
              student_survey_link: {
                text: 'Student Link',
                url: 'http://google.com',
                long_desc: 'This is a long description for student link',
              },
              mentor_survey_link: {
                text: 'Mentor Link',
                url: 'http://bing.com',
                long_desc: 'This is a long description for mentor link',
              },
              team_building_enabled: 1,
              select_regional_pitch_event: 0,
              judging_round: 'qf',
              display_scores: 1,
            },
            cancelButtonUrl: '/admin/dashboard',
          },
        }
      )

      expect(wrapper.vm.$store.state.settings).toEqual({
        student_signup: 1,
        mentor_signup: 0,
        student_dashboard_text: 'Student dashboard text',
        mentor_dashboard_text: 'Mentor dashboard text',
        judge_dashboard_text: 'Judge dashboard text',
        regional_ambassador_dashboard_text: 'RA dashboard text',
        student_survey_link: {
          text: 'Student Link',
          url: 'http://google.com',
          long_desc: 'This is a long description for student link',
        },
        mentor_survey_link: {
          text: 'Mentor Link',
          url: 'http://bing.com',
          long_desc: 'This is a long description for mentor link',
        },
        team_building_enabled: 1,
        team_submissions_editable: 0,
        select_regional_pitch_event: 0,
        judging_round: 'qf',
        display_scores: 1,
      })

      expect(wrapper.vm.$store.state.cancelButtonUrl)
        .toEqual('/admin/dashboard')
    })

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
          propsData: {
            cancelButtonUrl: '/admin/dashboard',
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