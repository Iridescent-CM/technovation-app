class SeasonTogglesSerializer
  include FastJsonapi::ObjectSerializer

  set_id do
    1 # FastJsonapi requires an id
  end

  attribute :student_signup do |season_toggles|
    season_toggles.signup_enabled?('student')
  end

  attribute :mentor_signup do |season_toggles|
    season_toggles.signup_enabled?('mentor')
  end

  attribute :judge_signup do |season_toggles|
    season_toggles.signup_enabled?('judge')
  end

  attribute :student_dashboard_text do |season_toggles|
    season_toggles.dashboard_text('student')
  end

  attribute :mentor_dashboard_text do |season_toggles|
    season_toggles.dashboard_text('mentor')
  end

  attribute :judge_dashboard_text do |season_toggles|
    season_toggles.dashboard_text('judge')
  end

  attribute :chapter_ambassador_dashboard_text do |season_toggles|
    season_toggles.dashboard_text('chapter_ambassador')
  end

  attribute :student_survey_link do |season_toggles|
    {
      text: season_toggles.survey_link('student', :text),
      url: season_toggles.survey_link('student', :url),
      long_desc: season_toggles.survey_link('student', :long_desc)
    }
  end

  attribute :mentor_survey_link do |season_toggles|
    {
      text: season_toggles.survey_link('mentor', :text),
      url: season_toggles.survey_link('mentor', :url),
      long_desc: season_toggles.survey_link('mentor', :long_desc)
    }
  end

  attribute :team_building_enabled do |season_toggles|
    season_toggles.team_building_enabled?
  end

  attribute :team_submissions_editable do |season_toggles|
    season_toggles.team_submissions_editable?
  end

  attribute :select_regional_pitch_event do |season_toggles|
    season_toggles.select_regional_pitch_event?
  end

  attribute :judging_round do |season_toggles|
    season_toggles.judging_round.to_s
  end

  attribute :display_scores do |season_toggles|
    season_toggles.display_scores?
  end
end
