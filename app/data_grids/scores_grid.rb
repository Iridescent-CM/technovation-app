class ScoresGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search, :current_account

  self.batch_size = 10

  filter :round,
  :enum,
  select: -> { [
    ['Quarterfinals', 'quarterfinals'],
    ['Semifinals', 'semifinals'],
  ] } do |value, scope, grid|
    scope.public_send(value)
  end

  filter :deleted,
  :enum,
  select: -> { [
    ['Include deleted scores', 'with_deleted'],
    ['Only show deleted scores', 'only_deleted'],
  ] } do |value, scope, grid|
    scope.public_send(value)
  end

  scope do
    SubmissionScore.current
      .includes({ team_submission: :team }, :judge_profile)
      .references(:teams, :team_submissions, :judge_profiles)
  end

  column :round

  column :submission_contest_rank do
    team_submission.contest_rank
  end

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

  column :submission_quarterfinals_score do
    team_submission.quarterfinals_average_score
  end

  column :submission_unofficial_score do
    team_submission.average_unofficial_score
  end

  column :submission_semifinals_score do
    team_submission.semifinals_average_score
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

  column :id

  column :team_id, header: :team_id do
    team_submission.team_id
  end

  column :team_submission_id, header: :team_submission_id

  column :judge_account_id, header: :judge_account_id do
    judge_profile.account_id
  end

  column :deleted do
    deleted? ? "yes" : "no"
  end

  column :view, html: true do |submission_score|
    link_to(
      web_icon("list-ul", size: 16, remote: true),
      [current_scope, :score, id: submission_score.id],
      {
        class: "view-details",
        data: { turbolinks: false }
      }
    )
  end
end
