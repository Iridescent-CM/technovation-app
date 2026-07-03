<template>
  <div id="surveys">
    <h4>Survey Links</h4>

    <div class="notice info hint">
      Please use a full URL with correct formatting.<br />
      (i.e., you must include the "https://" part)
    </div>

    <div ref="studentSurvey">
      <p class="margin--t-none">
        <label for="season_toggles_student_survey_link_text">Students</label>
        <input
          id="season_toggles_student_survey_link_text"
          v-model="$store.state.student_survey_link.text"
          placeholder="Headline call to action (keep it short)"
          type="text"
          :disabled="!isSuperAdmin"
        />
        <input
          id="season_toggles_student_survey_link_url"
          v-model="$store.state.student_survey_link.url"
          placeholder="URL"
          type="text"
          :disabled="!isSuperAdmin"
        />
      </p>
      <p class="margin--t-none">
        <label for="season_toggles_student_survey_link_long_desc"
          >(optional popup modal text)</label
        >
        <textarea
          id="season_toggles_student_survey_link_long_desc"
          v-model="$store.state.student_survey_link.long_desc"
          placeholder="Add more text that appears only in the popup modal"
          :disabled="!isSuperAdmin"
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
          id="season_toggles_mentor_survey_link_text"
          v-model="$store.state.mentor_survey_link.text"
          placeholder="Headline call to action (keep it short)"
          type="text"
          :disabled="!isSuperAdmin"
        />
        <input
          id="season_toggles_mentor_survey_link_url"
          v-model="$store.state.mentor_survey_link.url"
          placeholder="URL"
          type="text"
          :disabled="!isSuperAdmin"
        />
      </p>
      <p class="margin--t-none">
        <label for="season_toggles_mentor_survey_link_long_desc"
          >(optional popup modal text)</label
        >
        <textarea
          id="season_toggles_mentor_survey_link_long_desc"
          v-model="$store.state.mentor_survey_link.long_desc"
          placeholder="Add more text that appears only in the popup modal"
          :disabled="!isSuperAdmin"
        />
      </p>
      <div class="notice info hint">
        The text *and* URL must both be filled in or nothing will appear.
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  name: "SurveysSection",
  computed: {
    ...mapGetters(["isSuperAdmin"]),
  },
};
</script>

<style scoped></style>
