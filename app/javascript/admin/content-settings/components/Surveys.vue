<template>
  <div id="surveys">
    <h4> Pop-up resets</h4>

    <div class="margin--b-xlarge">
      <button
         class="button secondary"
         @click.prevent="resetPopups('student')"
      >Reset student pop-ups</button>

      <button
         class="button secondary"
         @click.prevent="resetPopups('mentor')"
      >Reset mentor pop-ups</button>
    </div>

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
          v-model="$store.state.student_survey_link.text"
        >
        <input
          placeholder="URL"
          type="text"
          id="season_toggles_student_survey_link_url"
          v-model="$store.state.student_survey_link.url"
        >
      </p>
      <p class="margin--t-none">
        <label for="season_toggles_student_survey_link_long_desc">(optional popup modal text)</label>
        <textarea
          placeholder="Add more text that appears only in the popup modal"
          id="season_toggles_student_survey_link_long_desc"
          v-model="$store.state.student_survey_link.long_desc"
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
          v-model="$store.state.mentor_survey_link.text"
        >
        <input
          placeholder="URL"
          type="text"
          id="season_toggles_mentor_survey_link_url"
          v-model="$store.state.mentor_survey_link.url"
        >
      </p>
      <p class="margin--t-none">
        <label for="season_toggles_mentor_survey_link_long_desc">(optional popup modal text)</label>
        <textarea
          placeholder="Add more text that appears only in the popup modal"
          id="season_toggles_mentor_survey_link_long_desc"
          v-model="$store.state.mentor_survey_link.long_desc"
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

  methods: {
    resetPopups (scope) {
      this.confirmReset(scope)
      .then(() => {
        window.axios.post('/admin/survey_popup_resets', {
          scope: scope
        })
        .then(() => {
          displayFlashMessage(`Survey pop-ups reset for all ${scope}s`)
        })
        .catch(err => {
          displayFlashMessage('Something went wong', 'error')
        })
      })
      .catch(() => {}) // action cancelled
    },

    confirmReset (scope) {
      return new Promise((resolve, reject) => {
        swal({
          html: `You are about to RESET survey pop-ups for ALL ${scope.toUpperCase()}S`,
          cancelButtonText: "No, go back",
          confirmButtonText: "Yes, do it",
          confirmButtonColor: "#5ABF94",
          showCancelButton: true,
          reverseButtons: true,
          focusCancel: true,
        }).then(function(result) {
          if (result.value) {
            resolve()
          }
          else {
            reject()
          }
        })
      })
    }
  }
}
</script>

<style scoped>
</style>