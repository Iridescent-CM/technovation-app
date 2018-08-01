import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Surveys from 'admin/content-settings/components/Surveys'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Surveys component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Surveys,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Surveys.name).toEqual('surveys-section')
  })

  describe('markup', () => {

    const scopes = {
      student: {
        text: 'Go to Student Survey',
        url: 'https://bing.com',
        long_desc: 'Student survey long description.',
      },
      mentor: {
        text: 'Go to Mentor Survey',
        url: 'https://google.com',
        long_desc: 'Mentor survey long description.',
      },
    }

    it('contains the proper HTML based on data', () => {
      wrapper = shallowMount(
        Surveys,
        {
          localVue,
          store: mockStore.createMocks({
            state: {
              settings: {
                student_survey_link: scopes.student,
                mentor_survey_link: scopes.mentor,
              },
            },
          }).store,
        }
      )

      Object.keys(scopes).forEach((scope) => {
        const survey = wrapper.find({ ref: `${scope}Survey` })

        const sectionLabel = survey
          .find(`label[for="season_toggles_${scope}_survey_link_text"]`)

        const textInput = survey
          .find(`#season_toggles_${scope}_survey_link_text`)

        const urlInput = survey
          .find(`#season_toggles_${scope}_survey_link_url`)

        const descriptionLabel = survey
          .find(`label[for="season_toggles_${scope}_survey_link_long_desc"]`)

        const description = survey
          .find(`#season_toggles_${scope}_survey_link_long_desc`)

        const notice = survey.find('.notice')

        expect(sectionLabel.exists()).toBe(true)

        expect(textInput.attributes()).toEqual(
          expect.objectContaining({
            placeholder: 'Headline call to action (keep it short)',
            type: 'text',
            id: `season_toggles_${scope}_survey_link_text`,
          })
        )
        expect(textInput.element.value).toEqual(scopes[scope].text)

        expect(urlInput.attributes()).toEqual(
          expect.objectContaining({
            placeholder: 'URL',
            type: 'text',
            id: `season_toggles_${scope}_survey_link_url`,
          })
        )
        expect(urlInput.element.value).toEqual(scopes[scope].url)

        expect(descriptionLabel.exists()).toBe(true)

        expect(description.attributes()).toEqual(
          expect.objectContaining({
            placeholder: 'Add more text that appears only in the popup modal',
            id: `season_toggles_${scope}_survey_link_long_desc`,
          })
        )
        expect(description.element.value).toEqual(scopes[scope].long_desc)

        expect(notice.exists()).toBe(true)
      })
    })

  })

})