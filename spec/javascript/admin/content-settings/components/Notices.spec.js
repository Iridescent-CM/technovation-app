import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Notices from 'admin/content-settings/components/Notices'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Notices component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Notices,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Notices.name).toEqual('notices-section')
  })

  describe('markup', () => {

    const scopes = {
      student: 'Student notice text here.',
      mentor: 'Mentor notice text here.',
      judge: 'Judge notice text here.',
      chapter_ambassador: 'Chapter ambassador notice text here.',
    }

    beforeEach(() => {
      wrapper = shallowMount(
        Notices,
        {
          localVue,
          store: mockStore.createMocks({
            state: {
              student_dashboard_text: scopes.student,
              mentor_dashboard_text: scopes.mentor,
              judge_dashboard_text: scopes.judge,
              chapter_ambassador_dashboard_text: scopes.chapter_ambassador,
            },
          }).store,
        }
      )
    })

    it('contains the proper HTML based on data', () => {
      Object.keys(scopes).forEach((scope) => {
        const label = wrapper
          .find(`label[for="season_toggles_${scope}_dashboard_text"]`)

        const input = wrapper
          .find(`#season_toggles_${scope}_dashboard_text`)

        expect(label.exists()).toBe(true)
        expect(input.attributes()).toEqual(
          expect.objectContaining({
            id: `season_toggles_${scope}_dashboard_text`,
            type: 'text',
          })
        )
        expect(input.element.value).toEqual(scopes[scope])
      })
    })

  })

})
