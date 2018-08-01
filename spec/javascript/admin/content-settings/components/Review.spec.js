import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Review from 'admin/content-settings/components/Review'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Events component', () => {

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
        regional_ambassador_dashboard_text: 'Regional Ambassadors',
      },
      surveysFields: {
        student_survey_link: 'Students',
        mentor_survey_link: 'Mentors',
      },
      judgingRound: {
        off: 'Off',
        qf: 'Quarterfinals',
        sf: 'Semifinals',
      }
    })
  })

  describe('methods', () => {

    describe('buildFormInputsMarkup', () => {

      it('builds input markup to submit form', () => {
        const formData = {
          student_signup: 1,
          mentor_signup: false,
          student_dashboard_text: 'Student',
          mentor_dashboard_text: 'Mentor',
          judge_dashboard_text: 'Judge',
          regional_ambassador_dashboard_text: 'RA',
          student_survey_link: {
            text: 'Student Link',
            url: 'http://google.com',
            long_desc: 'This is a long student description',
          },
          mentor_survey_link: {
            text: 'Mentor Link',
            url: 'http://bing.com',
            long_desc: 'This is a long mentor description',
          },
        }

        const testElement = document.createElement('div')
        testElement.innerHTML = wrapper.vm.buildFormInputsMarkup(formData)

        const inputs = testElement.querySelectorAll('input')

        expect(inputs[0].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[student_signup]" value="1">')
        expect(inputs[1].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[mentor_signup]" value="0">')
        expect(inputs[2].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[student_dashboard_text]" value="Student">')
        expect(inputs[3].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[mentor_dashboard_text]" value="Mentor">')
        expect(inputs[4].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[judge_dashboard_text]" value="Judge">')
        expect(inputs[5].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[regional_ambassador_dashboard_text]" value="RA">')
        expect(inputs[6].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[student_survey_link][text]" value="Student Link">')
        expect(inputs[7].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[student_survey_link][url]" value="http://google.com">')
        expect(inputs[8].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[student_survey_link][long_desc]" value="This is a long student description">')
        expect(inputs[9].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[mentor_survey_link][text]" value="Mentor Link">')
        expect(inputs[10].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[mentor_survey_link][url]" value="http://bing.com">')
        expect(inputs[11].outerHTML)
          .toEqual('<input type="hidden" name="season_toggles[mentor_survey_link][long_desc]" value="This is a long mentor description">')
      })

    })

  })

  describe('computed properties', () => {

    describe('formData', () => {

      it('returns an object used for populating form inputs based on dynamic data', () => {
        wrapper = shallowMount(
          Review,
          {
            localVue,
            store: mockStore
              .createMocks({
                state: {
                  settings: {
                    student_dashboard_text: 'Student',
                    mentor_dashboard_text: 'Mentor',
                    judge_dashboard_text: 'Judge',
                    regional_ambassador_dashboard_text: 'RA',
                    student_survey_link: {
                      text: 'Student Link',
                      url: 'http://google.com',
                      long_desc: 'Student link long description',
                    },
                    mentor_survey_link: {
                      text: 'Mentor Link',
                      url: 'http://bing.com',
                      long_desc: 'Mentor link long description',
                    },
                    judging_round: 'off',
                  },
                },
              })
              .store,
            computed: {
              studentSignup () {
                return true
              },
              mentorSignup () {
                return false
              },
              teamBuildingEnabled () {
                return true
              },
              teamSubmissionsEditable () {
                return false
              },
              selectRegionalPitchEvent () {
                return true
              },
              displayScores () {
                return false
              },
            },
          }
        )

        expect(wrapper.vm.formData).toEqual({
          student_signup: true,
          mentor_signup: false,
          student_dashboard_text: 'Student',
          mentor_dashboard_text: 'Mentor',
          judge_dashboard_text: 'Judge',
          regional_ambassador_dashboard_text: 'RA',
          student_survey_link: {
            text: 'Student Link',
            url: 'http://google.com',
            long_desc: 'Student link long description',
          },
          mentor_survey_link: {
            text: 'Mentor Link',
            url: 'http://bing.com',
            long_desc: 'Mentor link long description',
          },
          team_building_enabled: true,
          team_submissions_editable: false,
          select_regional_pitch_event: true,
          judging_round: 'off',
          display_scores: false,
        })
      })

    })

    describe('studentSignup', () => {

      it('returns false if judging is enabled', () => {
        wrapper.vm.$store.state.settings.judging_round = 'qf'
        wrapper.vm.$store.state.settings.student_signup = 1

        expect(wrapper.vm.studentSignup).toBeFalsy()
      })

      it('returns false if judging is not enabled and value is falsy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.student_signup = 0

        expect(wrapper.vm.studentSignup).toBeFalsy()
      })

      it('returns true if judging is not enabled and value is truthy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.student_signup = 1

        expect(wrapper.vm.studentSignup).toBeTruthy()
      })

    })

    describe('mentorSignup', () => {

      it('returns false if judging is enabled', () => {
        wrapper.vm.$store.state.settings.judging_round = 'qf'
        wrapper.vm.$store.state.settings.mentor_signup = 1

        expect(wrapper.vm.mentorSignup).toBeFalsy()
      })

      it('returns false if judging is not enabled and value is falsy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.mentor_signup = 0

        expect(wrapper.vm.mentorSignup).toBeFalsy()
      })

      it('returns true if judging is not enabled and value is truthy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.mentor_signup = 1

        expect(wrapper.vm.mentorSignup).toBeTruthy()
      })

    })

    describe('teamBuildingEnabled', () => {

      it('returns false if judging is enabled', () => {
        wrapper.vm.$store.state.settings.judging_round = 'qf'
        wrapper.vm.$store.state.settings.team_building_enabled = 1

        expect(wrapper.vm.teamBuildingEnabled).toBeFalsy()
      })

      it('returns false if judging is not enabled and value is falsy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.team_building_enabled = 0

        expect(wrapper.vm.teamBuildingEnabled).toBeFalsy()
      })

      it('returns true if judging is not enabled and value is truthy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.team_building_enabled = 1

        expect(wrapper.vm.teamBuildingEnabled).toBeTruthy()
      })

    })

    describe('teamSubmissionsEditable', () => {

      it('returns false if judging is enabled', () => {
        wrapper.vm.$store.state.settings.judging_round = 'qf'
        wrapper.vm.$store.state.settings.team_submissions_editable = 1

        expect(wrapper.vm.teamSubmissionsEditable).toBeFalsy()
      })

      it('returns false if judging is not enabled and value is falsy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.team_submissions_editable = 0

        expect(wrapper.vm.teamSubmissionsEditable).toBeFalsy()
      })

      it('returns true if judging is not enabled and value is truthy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.team_submissions_editable = 1

        expect(wrapper.vm.teamSubmissionsEditable).toBeTruthy()
      })

    })

    describe('selectRegionalPitchEvent', () => {

      it('returns false if judging is enabled', () => {
        wrapper.vm.$store.state.settings.judging_round = 'qf'
        wrapper.vm.$store.state.settings.select_regional_pitch_event = 1

        expect(wrapper.vm.selectRegionalPitchEvent).toBeFalsy()
      })

      it('returns false if judging is not enabled and value is falsy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.select_regional_pitch_event = 0

        expect(wrapper.vm.selectRegionalPitchEvent).toBeFalsy()
      })

      it('returns true if judging is not enabled and value is truthy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.select_regional_pitch_event = 1

        expect(wrapper.vm.selectRegionalPitchEvent).toBeTruthy()
      })

    })

    describe('displayScores', () => {

      it('returns false if judging is enabled', () => {
        wrapper.vm.$store.state.settings.judging_round = 'qf'
        wrapper.vm.$store.state.settings.display_scores = 1

        expect(wrapper.vm.displayScores).toBeFalsy()
      })

      it('returns false if judging is not enabled and value is falsy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.display_scores = 0

        expect(wrapper.vm.displayScores).toBeFalsy()
      })

      it('returns true if judging is not enabled and value is truthy', () => {
        wrapper.vm.$store.state.settings.judging_round = 'off'
        wrapper.vm.$store.state.settings.display_scores = 1

        expect(wrapper.vm.displayScores).toBeTruthy()
      })

    })

  })

  describe('markup', () => {

    describe('registration fields section', () => {

      describe('student signup field', () => {

        it('displays "yes" if enabled', () => {
          wrapper.vm.$store.state.settings.student_signup = 1
          wrapper.vm.$store.state.settings.judging_round = 'off'

          const yes = wrapper.find({ ref: 'signupFieldStudents' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'signupFieldStudents' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', () => {
          wrapper.vm.$store.state.settings.student_signup = 0
          wrapper.vm.$store.state.settings.judging_round = 'off'

          const yes = wrapper.find({ ref: 'signupFieldStudents' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'signupFieldStudents' })
            .find('.off').exists()

          expect(yes).toBe(false)
          expect(no).toBe(true)
        })

      })

      describe('mentor signup field', () => {

        it('displays "yes" if enabled', () => {
          wrapper.vm.$store.state.settings.mentor_signup = 1
          wrapper.vm.$store.state.settings.judging_round = 'off'

          const yes = wrapper.find({ ref: 'signupFieldMentors' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'signupFieldMentors' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', () => {
          wrapper.vm.$store.state.settings.mentor_signup = 0
          wrapper.vm.$store.state.settings.judging_round = 'off'

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

        it('displays a notice if no input available', () => {
          wrapper.vm.$store.state.settings.student_dashboard_text = ''

          const notice = wrapper.find({ ref: 'noticeFieldHintStudents' })
          const input = wrapper.find({ ref: 'noticeFieldLabelStudents' })

          expect(notice.exists()).toBe(true)
          expect(input.exists()).toBe(false)
        })

        it('displays the input if available', () => {
          wrapper.vm.$store.state.settings
            .student_dashboard_text = 'Hello world, this is a test.'

            const notice = wrapper.find({ ref: 'noticeFieldHintStudents' })
            const input = wrapper.find({ ref: 'noticeFieldLabelStudents' })

            expect(notice.exists()).toBe(false)
            expect(input.text()).toBe('Hello world, this is a test.')
        })

      })

      describe('mentors field', () => {

        it('displays a notice if no input available', () => {
          wrapper.vm.$store.state.settings.mentor_dashboard_text = ''

          const notice = wrapper.find({ ref: 'noticeFieldHintMentors' })
          const input = wrapper.find({ ref: 'noticeFieldLabelMentors' })

          expect(notice.exists()).toBe(true)
          expect(input.exists()).toBe(false)
        })

        it('displays the input if available', () => {
          wrapper.vm.$store.state.settings
            .mentor_dashboard_text = 'Hello world, this is a test.'

            const notice = wrapper.find({ ref: 'noticeFieldHintMentors' })
            const input = wrapper.find({ ref: 'noticeFieldLabelMentors' })

            expect(notice.exists()).toBe(false)
            expect(input.text()).toBe('Hello world, this is a test.')
        })

      })

      describe('judges field', () => {

        it('displays a notice if no input available', () => {
          wrapper.vm.$store.state.settings.judge_dashboard_text = ''

          const notice = wrapper.find({ ref: 'noticeFieldHintJudges' })
          const input = wrapper.find({ ref: 'noticeFieldLabelJudges' })

          expect(notice.exists()).toBe(true)
          expect(input.exists()).toBe(false)
        })

        it('displays the input if available', () => {
          wrapper.vm.$store.state.settings
            .judge_dashboard_text = 'Hello world, this is a test.'

            const notice = wrapper.find({ ref: 'noticeFieldHintJudges' })
            const input = wrapper.find({ ref: 'noticeFieldLabelJudges' })

            expect(notice.exists()).toBe(false)
            expect(input.text()).toBe('Hello world, this is a test.')
        })

      })

      describe('RA field', () => {

        it('displays a notice if no input available', () => {
          wrapper.vm.$store.state.settings.regional_ambassador_dashboard_text = ''

          const notice = wrapper
            .find({ ref: 'noticeFieldHintRegionalAmbassadors' })
          const input = wrapper
            .find({ ref: 'noticeFieldLabelRegionalAmbassadors' })

          expect(notice.exists()).toBe(true)
          expect(input.exists()).toBe(false)
        })

        it('displays the input if available', () => {
          wrapper.vm.$store.state.settings
            .regional_ambassador_dashboard_text = 'Hello world, this is a test.'

            const notice = wrapper
              .find({ ref: 'noticeFieldHintRegionalAmbassadors' })
            const input = wrapper
              .find({ ref: 'noticeFieldLabelRegionalAmbassadors' })

            expect(notice.exists()).toBe(false)
            expect(input.text()).toBe('Hello world, this is a test.')
        })

      })

    })

    describe('survey fields section', () => {

      beforeEach(() => {
        wrapper.vm.$store.state.settings.student_survey_link
          .text = 'Student Link'
        wrapper.vm.$store.state.settings.student_survey_link
          .url = 'http://google.com'
        wrapper.vm.$store.state.settings.student_survey_link
          .long_desc = 'Student link long description.'
        wrapper.vm.$store.state.settings.mentor_survey_link
          .text = 'Mentor Link'
        wrapper.vm.$store.state.settings.mentor_survey_link
          .url = 'http://bing.com'
        wrapper.vm.$store.state.settings.mentor_survey_link
          .long_desc = 'Mentor link long description.'
      })

      describe('students field', () => {

        it('displays a notice if text or URL input is not available', () => {
          wrapper.vm.$store.state.settings.student_survey_link.text = ''

          let notice = wrapper.find({ ref: 'surveyFieldTextUrlHintStudents' })
          let text = wrapper.find({ ref: 'surveyFieldTextStudents' })
          let url = wrapper.find({ ref: 'surveyFieldUrlStudents' })

          expect(notice.exists()).toBe(true)
          expect(text.exists()).toBe(false)
          expect(url.exists()).toBe(false)

          wrapper.vm.$store.state.settings.student_survey_link
            .text = 'Student Link'
          wrapper.vm.$store.state.settings.student_survey_link.url = ''

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

        it('displays a notice if long description is not available', () => {
          wrapper.vm.$store.state.settings.student_survey_link.long_desc = ''

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

        it('displays a notice if text or URL input is not available', () => {
          wrapper.vm.$store.state.settings.mentor_survey_link.text = ''

          let notice = wrapper.find({ ref: 'surveyFieldTextUrlHintMentors' })
          let text = wrapper.find({ ref: 'surveyFieldTextMentors' })
          let url = wrapper.find({ ref: 'surveyFieldUrlMentors' })

          expect(notice.exists()).toBe(true)
          expect(text.exists()).toBe(false)
          expect(url.exists()).toBe(false)

          wrapper.vm.$store.state.settings.mentor_survey_link
            .text = 'Student Link'
          wrapper.vm.$store.state.settings.mentor_survey_link.url = ''

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

        it('displays a notice if long description is not available', () => {
          wrapper.vm.$store.state.settings.mentor_survey_link.long_desc = ''

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

        it('displays "yes" if enabled', () => {
          wrapper.vm.$store.state.settings.team_building_enabled = 1
          wrapper.vm.$store.state.settings.judging_round = 'off'

          const yes = wrapper.find({ ref: 'teamBuildingEnabledField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'teamBuildingEnabledField' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', () => {
          wrapper.vm.$store.state.settings.team_building_enabled = 0
          wrapper.vm.$store.state.settings.judging_round = 'off'

          const yes = wrapper.find({ ref: 'teamBuildingEnabledField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'teamBuildingEnabledField' })
            .find('.off').exists()

          expect(yes).toBe(false)
          expect(no).toBe(true)
        })

      })

      describe('team submissions editable field', () => {

        it('displays "yes" if enabled', () => {
          wrapper.vm.$store.state.settings.team_submissions_editable = 1
          wrapper.vm.$store.state.settings.judging_round = 'off'

          const yes = wrapper.find({ ref: 'teamSubmissionsEditableField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'teamSubmissionsEditableField' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', () => {
          wrapper.vm.$store.state.settings.team_submissions_editable = 0
          wrapper.vm.$store.state.settings.judging_round = 'off'

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

        it('displays "yes" if enabled', () => {
          wrapper.vm.$store.state.settings.select_regional_pitch_event = 1
          wrapper.vm.$store.state.settings.judging_round = 'off'

          const yes = wrapper.find({ ref: 'selectRegionalPitchEventField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'selectRegionalPitchEventField' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', () => {
          wrapper.vm.$store.state.settings.select_regional_pitch_event = 0
          wrapper.vm.$store.state.settings.judging_round = 'off'

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

        it('displays the selected judging round', () => {
          wrapper.vm.$store.state.settings.judging_round = 'off'

          let round = wrapper.find({ ref: 'judgingRoundField' }).text()

          expect(round).toBe('Off')

          wrapper.vm.$store.state.settings.judging_round = 'qf'

          round = wrapper.find({ ref: 'judgingRoundField' }).text()

          expect(round).toBe('Quarterfinals')

          wrapper.vm.$store.state.settings.judging_round = 'sf'

          round = wrapper.find({ ref: 'judgingRoundField' }).text()

          expect(round).toBe('Semifinals')
        })

      })

    })

    describe('scores and certificates fields section', () => {

      describe('scores and certificates accessible field', () => {

        it('displays "yes" if enabled', () => {
          wrapper.vm.$store.state.settings.display_scores = 1
          wrapper.vm.$store.state.settings.judging_round = 'off'

          const yes = wrapper.find({ ref: 'displayScoresField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'displayScoresField' })
            .find('.off').exists()

          expect(yes).toBe(true)
          expect(no).toBe(false)
        })

        it('displays "no" if not enabled', () => {
          wrapper.vm.$store.state.settings.display_scores = 0
          wrapper.vm.$store.state.settings.judging_round = 'off'

          const yes = wrapper.find({ ref: 'displayScoresField' })
            .find('.on').exists()
          const no = wrapper.find({ ref: 'displayScoresField' })
            .find('.off').exists()

          expect(yes).toBe(false)
          expect(no).toBe(true)
        })

      })

    })

    describe('cancel button', () => {

      it('links to the cancel button URL contained in the state', () => {
        wrapper.vm.$store.state.cancelButtonUrl = 'http://youtube.com'

        const cancelButton = wrapper.find({ ref: 'cancelButton' })

        expect(cancelButton.attributes().href).toEqual('http://youtube.com')
      })

    })

  })

})