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

})