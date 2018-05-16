class ScoresGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search, :current_account

  self.batch_size = 10

  scope do
    SubmissionScore.current
      .includes({ team_submission: :team }, :judge_profile)
      .references(:teams, :team_submissions, :judge_profiles)
  end

  column :division, mandatory: true do
    team_division_name
  end

  column :judge_name, mandatory: true do
    judge_profile.name
  end

  column :team_name, mandatory: true do
    team_submission.team_name
  end

  column :total, mandatory: true

  column :app_name, mandatory: true do
    team_submission.app_name
  end

  column :complete, mandatory: true do
    complete? ? "yes" : "no"
  end

  column :official, mandatory: true do
    official? ? "yes" : "no"
  end

  column :event_name, mandatory: true do
    team.event.name
  end

  column :event_type, mandatory: true
end