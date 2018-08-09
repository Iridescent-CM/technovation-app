const judgingEnabled = (state) => {
  return state.settings.judging_round !== 'off'
}

export default {
  judgingEnabled,

  formData (state) {
    const judgingRoundEnabled = judgingEnabled(state)

    return {
      // Registration
      student_signup: Boolean(
        !judgingRoundEnabled && state.settings.student_signup
      ),
      mentor_signup: Boolean(
        !judgingRoundEnabled && state.settings.mentor_signup
      ),
      judge_signup: Boolean(
        !judgingRoundEnabled && state.settings.judge_signup
      ),
      regional_ambassador_signup: Boolean(
        !judgingRoundEnabled && state.settings.regional_ambassador_signup
      ),

      // Notices
      student_dashboard_text: state.settings.student_dashboard_text,
      mentor_dashboard_text: state.settings.mentor_dashboard_text,
      judge_dashboard_text: state.settings.judge_dashboard_text,
      regional_ambassador_dashboard_text: state.settings
        .regional_ambassador_dashboard_text,

      // Surveys
      student_survey_link: {
        text: state.settings.student_survey_link.text,
        url: state.settings.student_survey_link.url,
        long_desc: state.settings.student_survey_link.long_desc,
      },
      mentor_survey_link: {
        text: state.settings.mentor_survey_link.text,
        url: state.settings.mentor_survey_link.url,
        long_desc: state.settings.mentor_survey_link.long_desc,
      },

      // Teams & Submissions
      team_building_enabled: Boolean(
        !judgingRoundEnabled && state.settings.team_building_enabled
      ),
      team_submissions_editable: Boolean(
        !judgingRoundEnabled && state.settings.team_submissions_editable
      ),

      // Events
      select_regional_pitch_event: Boolean(
        !judgingRoundEnabled && state.settings.select_regional_pitch_event
      ),

      // Judging
      judging_round: state.settings.judging_round,

      // Scores & Certificates
      display_scores: Boolean(
        !judgingRoundEnabled && state.settings.display_scores
      ),
    }
  },
}