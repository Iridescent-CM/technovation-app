const judgingEnabled = (state) => {
  return state.judging_round !== 'off' && state.judging_round !== 'finished'
}

export default {
  judgingEnabled,

  formData (state) {
    const judgingRoundEnabled = judgingEnabled(state)

    return {
      // Registration
      student_signup: Boolean(!judgingRoundEnabled && state.student_signup),
      mentor_signup: Boolean(!judgingRoundEnabled && state.mentor_signup),
      judge_signup: Boolean(state.judge_signup),
      chapter_ambassador_signup: Boolean(
        !judgingRoundEnabled && state.chapter_ambassador_signup
      ),

      // Notices
      student_dashboard_text: state.student_dashboard_text,
      mentor_dashboard_text: state.mentor_dashboard_text,
      judge_dashboard_text: state.judge_dashboard_text,
      chapter_ambassador_dashboard_text: state
        .chapter_ambassador_dashboard_text,

      // Surveys
      student_survey_link: {
        text: state.student_survey_link.text,
        url: state.student_survey_link.url,
        long_desc: state.student_survey_link.long_desc,
      },
      mentor_survey_link: {
        text: state.mentor_survey_link.text,
        url: state.mentor_survey_link.url,
        long_desc: state.mentor_survey_link.long_desc,
      },

      // Teams & Submissions
      team_building_enabled: Boolean(
        !judgingRoundEnabled && state.team_building_enabled
      ),
      team_submissions_editable: Boolean(
        !judgingRoundEnabled && state.team_submissions_editable
      ),

      // Events
      select_regional_pitch_event: Boolean(
        !judgingRoundEnabled && state.select_regional_pitch_event
      ),

      // Judging
      judging_round: state.judging_round,

      // Scores & Certificates
      display_scores: Boolean(!judgingRoundEnabled && state.display_scores),
    }
  },
}
