<template>
  <div id="notices">
    <h4>Dashboard Notices</h4>

    <div class="notice info hint">
      Please keep these short!<br>
      ex: "Submission Deadline: April 23rd" or "Round One Judging Is Open!"
    </div>

    <p>
      <label for="season_toggles_student_dashboard_text">Students</label>
      <input
        id="season_toggles_student_dashboard_text"
        type="text"
        v-model="$store.state.student_dashboard_text"
        :disabled="!isSuperAdmin"
      >
    </p>

    <p>
      <label for="season_toggles_mentor_dashboard_text">Mentors</label>
      <input
        id="season_toggles_mentor_dashboard_text"
        type="text"
        v-model="$store.state.mentor_dashboard_text"
        :disabled="!isSuperAdmin"
      >
    </p>

    <p>
      <label for="season_toggles_judge_dashboard_text">Judges</label>
      <input
        id="season_toggles_judge_dashboard_text"
        type="text"
        v-model="$store.state.judge_dashboard_text"
        :disabled="!isSuperAdmin"
      >
    </p>

    <p>
      <label for="season_toggles_chapter_ambassador_dashboard_text">Chapter ambassadors</label>
      <input
        id="season_toggles_chapter_ambassador_dashboard_text"
        type="text"
        v-model="$store.state.chapter_ambassador_dashboard_text"
        :disabled="!isSuperAdmin"
      >
    </p>
  </div>
</template>

<script>
import {mapGetters} from "vuex";

export default {
  name: 'notices-section',

  computed: {
    ...mapGetters(['isSuperAdmin'])
  }
}
</script>

<style scoped>
</style>
