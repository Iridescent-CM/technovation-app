<template>
  <div id="surveys">
    <h4>Survey Links</h4>

    <div class="notice info hint">
      Please use a full URL with correct formatting.<br>
      (i.e., you must include the "https://" part)
    </div>

    <div ref="studentSurvey">
      <p class="margin--t-none">
        <label for="season_toggles_student_survey_link_text">Students</label>
        <input
          placeholder="Headline call to action (keep it short)"
          type="text"
          id="season_toggles_student_survey_link_text"
          v-model="$store.state.settings.student_survey_link.text"
        >
        <input
          placeholder="URL"
          type="text"
          id="season_toggles_student_survey_link_url"
          v-model="$store.state.settings.student_survey_link.url"
        >
      </p>
      <p class="margin--t-none">
        <label for="season_toggles_student_survey_link_long_desc">(optional popup modal text)</label>
        <textarea
          placeholder="Add more text that appears only in the popup modal"
          id="season_toggles_student_survey_link_long_desc"
          v-model="$store.state.settings.student_survey_link.long_desc"
        />
      </p>
      <div class="notice info hint">
        The text *and* URL must both be filled in or nothing will appear.
      </div>
    </div>

    <div ref="mentorSurvey">
      <p class="margin--t-none">
        <label for="season_toggles_mentor_survey_link_text">Mentors</label>
        <input
          placeholder="Headline call to action (keep it short)"
          type="text"
          id="season_toggles_mentor_survey_link_text"
          v-model="$store.state.settings.mentor_survey_link.text"
        >
        <input
          placeholder="URL"
          type="text"
          id="season_toggles_mentor_survey_link_url"
          v-model="$store.state.settings.mentor_survey_link.url"
        >
      </p>
      <p class="margin--t-none">
        <label for="season_toggles_mentor_survey_link_long_desc">(optional popup modal text)</label>
        <textarea
          placeholder="Add more text that appears only in the popup modal"
          id="season_toggles_mentor_survey_link_long_desc"
          v-model="$store.state.settings.mentor_survey_link.long_desc"
        />
      </p>
      <div class="notice info hint">
        The text *and* URL must both be filled in or nothing will appear.
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'surveys-section',
}
</script>

<style scoped>
</style>