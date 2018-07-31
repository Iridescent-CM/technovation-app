<template>
  <div class="modal-content">
    <div id="season_review">
      <div class="review-panel">
        <h4 class="reset">User Registrations</h4>
        <div class="review-label">
          <p>
            Students
            <strong :class="{ on: studentSignup, off: !studentSignup }">
              {{ studentSignup ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
        <div class="review-label">
          <p>
            Mentors
            <strong :class="{ on: mentorSignup, off: !mentorSignup }">
              {{ mentorSignup ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Dashboard Notices</h4>
        <div v-for="(label, key) in noticesFields" :key="key">
          <p class="review-label">{{ label }}</p>
          <p
            v-if="formData[key] === ''"
            class="hint"
          >Not filled in, nothing will appear</p>
          <p v-else>{{ formData[key] }}</p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Survey Links</h4>

        <div v-for="(label, key) in surveysFields" :key="key">
          <p class="review-label">{{ label }}</p>

          <p
            v-if="formData[key].text === '' || formData[key].url === ''"
            class="hint"
          >Not filled in completely, nothing will appear.</p>

          <template v-else>
            <p class="part-of-many">{{ formData[key].text }}</p>
            <p class="part-of-many">{{ formData[key].url }}</p>
          </template>

          <p class="review-label-subset">(optional popup modal text)</p>

          <p
            v-if="formData[key].long_desc === ''"
            class="hint"
          >Not filled in, nothing will appear</p>
          <p v-else>{{ formData[key].long_desc }}</p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Teams &amp; Submissions</h4>
        <div class="review-label">
          <p>
            Forming teams allowed
            <strong :class="{ on: teamBuildingEnabled, off: !teamBuildingEnabled }">
              {{ teamBuildingEnabled ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
        <div class="review-label">
          <p>
            Team submissions are editable
            <strong :class="{ on: teamSubmissionsEditable, off: !teamSubmissionsEditable }">
              {{ teamSubmissionsEditable ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Regional Pitch Events</h4>
        <div class="review-label">
          <p>
            Selecting retional pitch events allowed
            <strong :class="{ on: selectRegionalPitchEvent, off: !selectRegionalPitchEvent }">
              {{ selectRegionalPitchEvent ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Judging Round</h4>
        <p class="review-label">{{ judgingRound[formData.judging_round] }}</p>
      </div>

      <div class="review-panel">
        <h4 class="reset">Scores &amp; Certificates</h4>
        <div class="review-label">
          <p>
            Scores &amp; Certificates Accessible
            <strong :class="{ on: displayScores, off: !displayScores }">
              {{ displayScores ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
      </div>
    </div>

    <div class="notice warning">
      The changes you make here affect the end-user experience.<br>
      Please double check everything before saving.
    </div>

    <div>
      <button
        type="submit"
        class="button primary"
        @click.prevent="saveSettings"
      >Save these settings</button>
      or
      <a :href="$store.state.cancelButtonUrl">cancel</a>
    </div>

    <div ref="formData"></div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'review-and-save-settings',

  data () {
    return {
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
    }
  },

  methods: {
    saveSettings () {
      this.$refs.formData.innerHTML = this.buildFormInputsMarkup(this.formData)
      //document.getElementById('season_schedule').submit()
    },

    buildFormInputsMarkup (formData, prefix = 'season_toggles') {
      let markup = ''

      Object.keys(formData).forEach((key) => {
        const inputName = `${prefix}[${key}]`
        let inputValue

        if (formData[key] === false) {
          inputValue = 0
        } else if (formData[key] === true) {
          inputValue = 1
        } else {
          inputValue = formData[key]
        }

        if (inputValue !== null && typeof inputValue === 'object') {
          markup += this.buildFormInputsMarkup(inputValue, inputName)
        } else {
          markup += `
            <input
              type="hidden"
              name="${inputName}"
              value="${inputValue}"
            />`
        }
      })

      return markup
    },
  },

  computed: {
    ...mapGetters([
      'judgingEnabled',
    ]),

    formData () {
      return {
        // Registration
        student_signup: this.studentSignup,
        mentor_signup: this.mentorSignup,
        // Notices
        student_dashboard_text: this.$store.state.settings
          .student_dashboard_text,
        mentor_dashboard_text: this.$store.state.settings
          .mentor_dashboard_text,
        judge_dashboard_text: this.$store.state.settings
          .judge_dashboard_text,
        regional_ambassador_dashboard_text: this.$store.state.settings
          .regional_ambassador_dashboard_text,
        // Surveys
        student_survey_link: {
          text: this.$store.state.settings.student_survey_link.text,
          url: this.$store.state.settings.student_survey_link.url,
          long_desc: this.$store.state.settings.student_survey_link.long_desc,
        },
        mentor_survey_link: {
          text: this.$store.state.settings.mentor_survey_link.text,
          url: this.$store.state.settings.mentor_survey_link.url,
          long_desc: this.$store.state.settings.mentor_survey_link.long_desc,
        },
        // Teams & Submissions
        team_building_enabled: this.teamBuildingEnabled,
        team_submissions_editable: this.teamSubmissionsEditable,
        // Events
        select_regional_pitch_event: this.selectRegionalPitchEvent,
        // Judging
        judging_round: this.$store.state.settings.judging_round,
        // Scores & Certificates
        display_scores: this.displayScores,
      }
    },

    studentSignup () {
      return !this.judgingEnabled && this.$store.state.settings.student_signup
    },

    mentorSignup () {
      return !this.judgingEnabled && this.$store.state.settings.mentor_signup
    },

    teamBuildingEnabled () {
      return !this.judgingEnabled && this.$store.state.settings
        .team_building_enabled
    },

    teamSubmissionsEditable () {
      return !this.judgingEnabled && this.$store.state.settings
        .team_submissions_editable
    },

    selectRegionalPitchEvent () {
      return !this.judgingEnabled && this.$store.state.settings
        .select_regional_pitch_event
    },

    displayScores () {
      return !this.judgingEnabled && this.$store.state.settings.display_scores
    },
  },
}
</script>

<style scoped>
</style>