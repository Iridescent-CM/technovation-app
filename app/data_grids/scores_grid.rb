class ScoresGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search, :current_account

  self.batch_size = 10

  filter :round

  scope do
    SubmissionScore.current
      .includes({ team_submission: :team }, :judge_profile)
      .references(:teams, :team_submissions, :judge_profiles)
  end

  column :round

  column :division do
    team_division_name
  end

  column :judge_name do
    judge_profile.name
  end

  column :team_name do
    team_submission.team_name
  end

  column :total

  column :app_name do
    team_submission.app_name
  end

  column :complete do
    complete? ? "yes" : "no"
  end

  column :official do
    official? ? "yes" : "no"
  end

  column :event_name do
    team.event.name
  end

  column :event_type

  column :country do
    FriendlyCountry.(team)
  end
end