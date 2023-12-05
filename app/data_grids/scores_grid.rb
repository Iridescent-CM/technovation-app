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

  filter :dropped,
  :enum,
  select: -> { [
    ['Only show dropped scores', 'dropped'],
  ] } do |value, scope, grid|
    scope.public_send(value)
  end

  filter :live_or_virtual,
    :enum,
    select: -> {
      [
        ["Virtual scores", "virtual"],
        ["Live event scores", "live"]
      ]
    } do |value, scope|
    scope.public_send(value)
  end

  scope do
    SubmissionScore.current.judge_not_deleted
      .includes({ team_submission: :team })
      .references(:teams, :team_submissions)
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

  column :dropped do
    dropped? ? "yes" : "no"
  end

  column :suspicious do
    suspicious? ? "yes" : "no"
  end

  column :suspicious_reasons do
    suspicious_reasons.join(". ")
  end

  column :updated do
    updated? ? "yes" : "no"
  end

  column :created_at do
    created_at.strftime("%Y-%m-%d %H:%M")
  end

  column :updated_at do
    updated_at.strftime("%Y-%m-%d %H:%M")
  end

  column :approved_at do
    approved? ? approved_at.strftime("%Y-%m-%d %H:%M") : "-"
  end

  column :view, html: true do |submission_score|
    html = link_to(
      web_icon("list-ul", size: 16, remote: true),
      send("#{current_scope}_score_path", id: submission_score.id),
      data: {
        turbolinks: false
      },
      class: "view-details"
    )

    html += " "
    html += link_to(
      web_icon("list-alt", size: 16, remote: true),
      send("#{current_scope}_score_detail_path", id: submission_score.team_submission.id),
      {
        "v-tooltip" => "'Read score details'",
        :data => {turbolinks: false}
      }
    )

    html
  end

  column :score_details_link, html: false do |submission_score|
    Rails.application.routes.url_helpers.url_for(controller: "admin/score_details", action: "show", id: submission_score.team_submission.id)
  end
end
