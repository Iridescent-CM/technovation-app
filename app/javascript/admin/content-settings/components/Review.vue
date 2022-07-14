<template>
  <div class="modal-content">
    <div id="season_review">
      <div class="review-panel">
        <h4 class="reset">User Registrations</h4>

        <div ref="signupFieldStudents" class="review-label">
          <p>
            Students
            <strong :class="{ on: formData.student_signup, off: !formData.student_signup }">
              {{ formData.student_signup ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>

        <div ref="signupFieldMentors" class="review-label">
          <p>
            Mentors
            <strong
              :class="{
                on: formData.mentor_signup,
                off: !formData.mentor_signup
              }"
            >
              {{ formData.mentor_signup ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>

        <div ref="signupFieldJudges" class="review-label">
          <p>
            Judges
            <strong
              :class="{
                on: formData.judge_signup,
                off: !formData.judge_signup
              }"
            >
              {{ formData.judge_signup ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Dashboard Notices</h4>
        <div
          v-for="(label, key) in noticesFields"
          :key="key"
        >
          <p class="review-label">{{ label }}</p>
          <p
            v-if="formData[key] === ''"
            class="hint"
            :ref="`noticeFieldHint${label.replace(' ', '')}`"
          >Not filled in, nothing will appear</p>
          <p
            v-else
            :ref="`noticeFieldLabel${label.replace(' ', '')}`
          ">{{ formData[key] }}</p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Survey Links</h4>

        <div v-for="(label, key) in surveysFields" :key="key">
          <p class="review-label">{{ label }}</p>

          <p
            v-if="formData[key].text === '' || formData[key].url === ''"
            class="hint"
            :ref="`surveyFieldTextUrlHint${label}`"
          >Not filled in completely, nothing will appear.</p>

          <template v-else>
            <p
              class="part-of-many"
              :ref="`surveyFieldText${label}`"
            >{{ formData[key].text }}</p>
            <p
              class="part-of-many"
              :ref="`surveyFieldUrl${label}`"
            >{{ formData[key].url }}</p>
          </template>

          <p class="review-label-subset">(optional popup modal text)</p>

          <p
            v-if="formData[key].long_desc === ''"
            class="hint"
            :ref="`surveyFieldDescHint${label}`"
          >Not filled in, nothing will appear</p>
          <p
            v-else
            :ref="`surveyFieldDesc${label}`"
          >{{ formData[key].long_desc }}</p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Teams &amp; Submissions</h4>
        <div ref="teamBuildingEnabledField" class="review-label">
          <p>
            Forming teams allowed
            <strong
              :class="{
                on: formData.team_building_enabled,
                off: !formData.team_building_enabled
              }"
            >
              {{ formData.team_building_enabled ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
        <div ref="teamSubmissionsEditableField" class="review-label">
          <p>
            Team submissions are editable
            <strong
              :class="{
                on: formData.team_submissions_editable,
                off: !formData.team_submissions_editable
              }"
            >
              {{ formData.team_submissions_editable ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Regional Pitch Events</h4>
        <div ref="selectRegionalPitchEventField" class="review-label">
          <p>
            Selecting retional pitch events allowed
            <strong
              :class="{
                on: formData.select_regional_pitch_event,
                off: !formData.select_regional_pitch_event
              }"
            >
              {{ formData.select_regional_pitch_event ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
      </div>

      <div class="review-panel">
        <h4 class="reset">Judging Round</h4>
        <p
          ref="judgingRoundField"
          class="review-label"
        >{{ judgingRound[formData.judging_round] }}</p>
      </div>

      <div class="review-panel">
        <h4 class="reset">Scores &amp; Certificates</h4>
        <div ref="displayScoresField" class="review-label">
          <p>
            Scores &amp; Certificates Accessible
            <strong
              :class="{
                on: formData.display_scores,
                off: !formData.display_scores
              }"
            >
              {{ formData.display_scores ? 'yes' : 'no' }}
            </strong>
          </p>
        </div>
      </div>
    </div>

    <div class="notice warning">
      The changes you make here affect the end-user experience.<br>
      Please double check everything before saving.
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'review-and-save-settings-section',

  data () {
    return {
      noticesFields: {
        student_dashboard_text: 'Students',
        mentor_dashboard_text: 'Mentors',
        judge_dashboard_text: 'Judges',
        chapter_ambassador_dashboard_text: 'Chapter Ambassadors',
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
    }
  },

  computed: {
    ...mapGetters([
      'judgingEnabled',
      'formData'
    ]),
  },
}
</script>
