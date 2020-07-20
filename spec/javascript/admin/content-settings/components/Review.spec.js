import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Review from 'admin/content-settings/components/Review'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Review component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Review,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Review.name).toEqual('review-and-save-settings-section')
  })

  it('has the correct default data', () => {
    expect(Review.data()).toEqual({
      noticesFields: {
        student_dashboard_text: 'Students',
        mentor_dashboard_text: 'Mentors',
        judge_dashboard_text: 'Judges',
        regional_ambassador_dashboard_text: 'Chapter Ambassadors',
      },
      surveysFields: {
        student_survey_link: 'Students',
        mentor_survey_link: 'Mentors',
      },
      judgingRound: {
        off: 'Off',
        qf: 'Quarterfinals',
        between: 'Between rounds',
        sf: 'Semifinals',
        finished: 'Finished',
      }
    })
  })

  describe('markup', () => {

    describe('registration fields section', () => {

      describe('student signup field', () => {

        it('displays "yes" if enabled', async () => {
          wrapper.vm.$store.state.student_signup = 1
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'signupFieldStudents' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'signupFieldStudents' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', async () => {
          wrapper.vm.$store.state.student_signup = 0
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'signupFieldStudents' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'signupFieldStudents' })
            .find('.off').exists()

          expect(yes).toBe(false)
          expect(no).toBe(true)
        })

      })

      describe('mentor signup field', () => {

        it('displays "yes" if enabled', async () => {
          wrapper.vm.$store.state.mentor_signup = 1
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'signupFieldMentors' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'signupFieldMentors' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', async () => {
          wrapper.vm.$store.state.mentor_signup = 0
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'signupFieldMentors' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'signupFieldMentors' })
            .find('.off').exists()

          expect(yes).toBe(false)
          expect(no).toBe(true)
        })

      })

    })

    describe('notice fields section', () => {

      describe('students field', () => {

        it('displays a notice if no input available', async () => {
          wrapper.vm.$store.state.student_dashboard_text = ''

          await wrapper.vm.$nextTick()

          const notice = wrapper.find({ ref: 'noticeFieldHintStudents' })
          const input = wrapper.find({ ref: 'noticeFieldLabelStudents' })

          expect(notice.exists()).toBe(true)
          expect(input.exists()).toBe(false)
        })

        it('displays the input if available', async () => {
          wrapper.vm.$store.state
            .student_dashboard_text = 'Hello world, this is a test.'

          await wrapper.vm.$nextTick()

          const notice = wrapper.find({ ref: 'noticeFieldHintStudents' })
          const input = wrapper.find({ ref: 'noticeFieldLabelStudents' })

          expect(notice.exists()).toBe(false)
          expect(input.text()).toBe('Hello world, this is a test.')
        })

      })

      describe('mentors field', () => {

        it('displays a notice if no input available', async () => {
          wrapper.vm.$store.state.mentor_dashboard_text = ''

          await wrapper.vm.$nextTick()

          const notice = wrapper.find({ ref: 'noticeFieldHintMentors' })
          const input = wrapper.find({ ref: 'noticeFieldLabelMentors' })

          expect(notice.exists()).toBe(true)
          expect(input.exists()).toBe(false)
        })

        it('displays the input if available', async () => {
          wrapper.vm.$store.state
            .mentor_dashboard_text = 'Hello world, this is a test.'

          await wrapper.vm.$nextTick()

          const notice = wrapper.find({ ref: 'noticeFieldHintMentors' })
          const input = wrapper.find({ ref: 'noticeFieldLabelMentors' })

          expect(notice.exists()).toBe(false)
          expect(input.text()).toBe('Hello world, this is a test.')
        })

      })

      describe('judges field', () => {

        it('displays a notice if no input available', async () => {
          wrapper.vm.$store.state.judge_dashboard_text = ''

          await wrapper.vm.$nextTick()

          const notice = wrapper.find({ ref: 'noticeFieldHintJudges' })
          const input = wrapper.find({ ref: 'noticeFieldLabelJudges' })

          expect(notice.exists()).toBe(true)
          expect(input.exists()).toBe(false)
        })

        it('displays the input if available', async () => {
          wrapper.vm.$store.state
            .judge_dashboard_text = 'Hello world, this is a test.'

          await wrapper.vm.$nextTick()

          const notice = wrapper.find({ ref: 'noticeFieldHintJudges' })
          const input = wrapper.find({ ref: 'noticeFieldLabelJudges' })

          expect(notice.exists()).toBe(false)
          expect(input.text()).toBe('Hello world, this is a test.')
        })

      })

      describe('RA field', () => {

        it('displays a notice if no input available', async () => {
          wrapper.vm.$store.state.regional_ambassador_dashboard_text = ''

          await wrapper.vm.$nextTick()

          const notice = wrapper
            .find({ ref: 'noticeFieldHintChapterAmbassadors' })
          const input = wrapper
            .find({ ref: 'noticeFieldLabelChapterAmbassadors' })

          expect(notice.exists()).toBe(true)
          expect(input.exists()).toBe(false)
        })

        it('displays the input if available', async () => {
          wrapper.vm.$store.state
            .regional_ambassador_dashboard_text = 'Hello world, this is a test.'

          await wrapper.vm.$nextTick()

          const notice = wrapper
            .find({ ref: 'noticeFieldHintChapterAmbassadors' })
          const input = wrapper
            .find({ ref: 'noticeFieldLabelChapterAmbassadors' })

          expect(notice.exists()).toBe(false)
          expect(input.text()).toBe('Hello world, this is a test.')
        })

      })

    })

    describe('survey fields section', () => {

      beforeEach(() => {
        wrapper.vm.$store.state.student_survey_link
          .text = 'Student Link'
        wrapper.vm.$store.state.student_survey_link
          .url = 'http://google.com'
        wrapper.vm.$store.state.student_survey_link
          .long_desc = 'Student link long description.'
        wrapper.vm.$store.state.mentor_survey_link
          .text = 'Mentor Link'
        wrapper.vm.$store.state.mentor_survey_link
          .url = 'http://bing.com'
        wrapper.vm.$store.state.mentor_survey_link
          .long_desc = 'Mentor link long description.'
      })

      describe('students field', () => {

        it('displays a notice if text or URL input is not available', async () => {
          wrapper.vm.$store.state.student_survey_link.text = ''

          await wrapper.vm.$nextTick()

          let notice = wrapper.find({ ref: 'surveyFieldTextUrlHintStudents' })
          let text = wrapper.find({ ref: 'surveyFieldTextStudents' })
          let url = wrapper.find({ ref: 'surveyFieldUrlStudents' })

          expect(notice.exists()).toBe(true)
          expect(text.exists()).toBe(false)
          expect(url.exists()).toBe(false)

          wrapper.vm.$store.state.student_survey_link
            .text = 'Student Link'
          wrapper.vm.$store.state.student_survey_link.url = ''

          await wrapper.vm.$nextTick()

          notice = wrapper.find({ ref: 'surveyFieldTextUrlHintStudents' })
          text = wrapper.find({ ref: 'surveyFieldTextStudents' })
          url = wrapper.find({ ref: 'surveyFieldUrlStudents' })

          expect(notice.exists()).toBe(true)
          expect(text.exists()).toBe(false)
          expect(url.exists()).toBe(false)
        })

        it('displays text and url input if they are both available', () => {
          const notice = wrapper.find({ ref: 'surveyFieldTextUrlHintStudents' })
          const text = wrapper.find({ ref: 'surveyFieldTextStudents' })
          const url = wrapper.find({ ref: 'surveyFieldUrlStudents' })

          expect(notice.exists()).toBe(false)
          expect(text.exists()).toBe(true)
          expect(url.exists()).toBe(true)
        })

        it('displays a notice if long description is not available', async () => {
          wrapper.vm.$store.state.student_survey_link.long_desc = ''

          await wrapper.vm.$nextTick()

          const notice = wrapper.find({ ref: 'surveyFieldDescHintStudents' })
          const description = wrapper.find({ ref: 'surveyFieldDescStudents' })

          expect(notice.exists()).toBe(true)
          expect(description.exists()).toBe(false)
        })

        it('displays long description if it is available', () => {
          const notice = wrapper.find({ ref: 'surveyFieldDescHintStudents' })
          const description = wrapper.find({ ref: 'surveyFieldDescStudents' })

          expect(notice.exists()).toBe(false)
          expect(description.exists()).toBe(true)
        })

      })

      describe('mentors field', () => {

        it('displays a notice if text or URL input is not available', async () => {
          wrapper.vm.$store.state.mentor_survey_link.text = ''

          await wrapper.vm.$nextTick()

          let notice = wrapper.find({ ref: 'surveyFieldTextUrlHintMentors' })
          let text = wrapper.find({ ref: 'surveyFieldTextMentors' })
          let url = wrapper.find({ ref: 'surveyFieldUrlMentors' })

          expect(notice.exists()).toBe(true)
          expect(text.exists()).toBe(false)
          expect(url.exists()).toBe(false)

          wrapper.vm.$store.state.mentor_survey_link
            .text = 'Student Link'
          wrapper.vm.$store.state.mentor_survey_link.url = ''

          await wrapper.vm.$nextTick()

          notice = wrapper.find({ ref: 'surveyFieldTextUrlHintMentors' })
          text = wrapper.find({ ref: 'surveyFieldTextMentors' })
          url = wrapper.find({ ref: 'surveyFieldUrlMentors' })

          expect(notice.exists()).toBe(true)
          expect(text.exists()).toBe(false)
          expect(url.exists()).toBe(false)
        })

        it('displays text and url input if they are both available', () => {
          const notice = wrapper.find({ ref: 'surveyFieldTextUrlHintMentors' })
          const text = wrapper.find({ ref: 'surveyFieldTextMentors' })
          const url = wrapper.find({ ref: 'surveyFieldUrlMentors' })

          expect(notice.exists()).toBe(false)
          expect(text.exists()).toBe(true)
          expect(url.exists()).toBe(true)
        })

        it('displays a notice if long description is not available', async () => {
          wrapper.vm.$store.state.mentor_survey_link.long_desc = ''

          await wrapper.vm.$nextTick()

          const notice = wrapper.find({ ref: 'surveyFieldDescHintMentors' })
          const description = wrapper.find({ ref: 'surveyFieldDescMentors' })

          expect(notice.exists()).toBe(true)
          expect(description.exists()).toBe(false)
        })

        it('displays long description if it is available', () => {
          const notice = wrapper.find({ ref: 'surveyFieldDescHintMentors' })
          const description = wrapper.find({ ref: 'surveyFieldDescMentors' })

          expect(notice.exists()).toBe(false)
          expect(description.exists()).toBe(true)
        })

      })

    })

    describe('teams and submissions fields section', () => {

      describe('team building enabled field', () => {

        it('displays "yes" if enabled', async () => {
          wrapper.vm.$store.state.team_building_enabled = 1
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'teamBuildingEnabledField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'teamBuildingEnabledField' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', async () => {
          wrapper.vm.$store.state.team_building_enabled = 0
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'teamBuildingEnabledField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'teamBuildingEnabledField' })
            .find('.off').exists()

          expect(yes).toBe(false)
          expect(no).toBe(true)
        })

      })

      describe('team submissions editable field', () => {

        it('displays "yes" if enabled', async () => {
          wrapper.vm.$store.state.team_submissions_editable = 1
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'teamSubmissionsEditableField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'teamSubmissionsEditableField' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', async () => {
          wrapper.vm.$store.state.team_submissions_editable = 0
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'teamSubmissionsEditableField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'teamSubmissionsEditableField' })
            .find('.off').exists()

          expect(yes).toBe(false)
          expect(no).toBe(true)
        })

      })

    })

    describe('regional pitch events fields section', () => {

      describe('select regional pitch event field', () => {

        it('displays "yes" if enabled', async () => {
          wrapper.vm.$store.state.select_regional_pitch_event = 1
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'selectRegionalPitchEventField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'selectRegionalPitchEventField' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', async () => {
          wrapper.vm.$store.state.select_regional_pitch_event = 0
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'selectRegionalPitchEventField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'selectRegionalPitchEventField' })
            .find('.off').exists()

          expect(yes).toBe(false)
          expect(no).toBe(true)
        })

      })

    })

    describe('judging round fields section', () => {

      describe('judging round field', () => {

        it('displays the selected judging round', async () => {
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          let round = wrapper.find({ ref: 'judgingRoundField' }).text()

          expect(round).toBe('Off')

          wrapper.vm.$store.state.judging_round = 'qf'

          await wrapper.vm.$nextTick()

          round = wrapper.find({ ref: 'judgingRoundField' }).text()

          expect(round).toBe('Quarterfinals')

          wrapper.vm.$store.state.judging_round = 'sf'

          await wrapper.vm.$nextTick()

          round = wrapper.find({ ref: 'judgingRoundField' }).text()

          expect(round).toBe('Semifinals')
        })

      })

    })

    describe('scores and certificates fields section', () => {

      describe('scores and certificates accessible field', () => {

        it('displays "yes" if enabled', async () => {
          wrapper.vm.$store.state.display_scores = 1
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'displayScoresField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'displayScoresField' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', async () => {
          wrapper.vm.$store.state.display_scores = 0
          wrapper.vm.$store.state.judging_round = 'off'

          await wrapper.vm.$nextTick()

          const yes = wrapper.find({ ref: 'displayScoresField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'displayScoresField' })
            .find('.off').exists()

          expect(yes).toBe(false)
          expect(no).toBe(true)
        })

      })

    })

  })

})
