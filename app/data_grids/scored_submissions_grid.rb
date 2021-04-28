class ScoredSubmissionsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search, :current_account

  self.batch_size = 10

  scope do
    TeamSubmission.complete.current
      .includes(:team, {submission_scores: :judge_profile})
      .references(:teams, :submission_scores, :judge_profiles)
  end

  column :contest_rank

  column :division do
    team_division_name
  end

  column :city do
    team.city
  end

  column :country do
    FriendlyCountry.new(team).country_name
  end

  column :state_province, header: "State" do
    FriendlySubregion.(team, prefix: false)
  end

  column :team_name, mandatory: true, html: false
  column :team_name, mandatory: true, html: true do |submission|
    link_to submission.team_name,
      [current_scope, submission.team, allow_out_of_region: true],
      data: {turbolinks: false}
  end

  column :app_name, mandatory: true, html: false
  column :app_description
  column :submission, mandatory: true, html: true do |submission|
    link_to submission.app_name,
      [current_scope, submission, allow_out_of_region: true],
      data: { turbolinks: false }
  end

  column :complete_scores, mandatory: true do |asset, grid|
    asset.public_send(
      "complete_#{grid.round}_official_submission_scores_count"
    )
  end

  column :incomplete_scores, mandatory: true do |asset, grid|
    asset.public_send(
      "pending_#{grid.round}_official_submission_scores_count"
    )
  end

  column :judge_recusal_count, header: "Recusals", mandatory: true, order: true

  column :quarterfinals_average, order: :quarterfinals_average_score, mandatory: true do |submission|
    str = submission.quarterfinals_average_score.to_s
    str += "/#{submission.total_possible_score}"
  end

  column :semifinals_average, order: :semifinals_average_score, mandatory: true, if: ->(g) {
    g.admin || SeasonToggles.display_scores?
  } do |submission|
    str = submission.semifinals_average_score.to_s
    str += "/#{submission.total_possible_score}"
  end

  column :quarterfinals_range, order: :quarterfinals_score_range do |submission|
    submission.quarterfinals_score_range
  end

  column :semifinals_range, order: :semifinals_score_range, if: ->(g) {
    g.admin || SeasonToggles.display_scores?
  } do |submission|
    submission.semifinals_score_range
  end

  column :quarterfinals_official_judging do |submission|
    if submission.team.selected_regional_pitch_event.live? &&
         submission.team.selected_regional_pitch_event.official?
      "live"
    else
      "virtual"
    end
  end

  column :view, mandatory: true, html: true do |submission, grid|
    html = link_to(
      web_icon('list-ul', size: 16, remote: true),
      [current_scope, :score_detail, id: submission.id],
      {
        class: "view-details",
        "v-tooltip" => "'Read score details'",
        data: { turbolinks: false },
      }
    )

    if grid.admin
      html += " "

      html += link_to(
        web_icon('photo', size: 16, remote: true),
        app_path(submission),
        class: "open-public",
        "v-tooltip" => "'Open public page'",
        target: :_blank,
        data: { turbolinks: false }
      )
    else
      html
    end
  end

  column :team_id, header: "Team ID", if: ->(g) { g.admin } do |submission|
    submission.team.id
  end

  column :submission_id, header: "Submission ID", if: ->(g) { g.admin } do |submission|
    submission.id
  end

  column :student_names do
    team.students.collect(&:name).join(",")
  end

  column :student_1_name, if: ->(grid) { grid.admin }  do
    team.students.first&.name
  end

  column :student_2_name, if: ->(grid) { grid.admin }  do
    team.students.second&.name
  end

  column :student_3_name, if: ->(grid) { grid.admin }  do
    team.students.third&.name
  end

  column :student_4_name, if: ->(grid) { grid.admin }  do
    team.students.fourth&.name
  end

  column :student_5_name, if: ->(grid) { grid.admin }  do
    team.students.fifth&.name
  end

  column :student_emails do
    team.students.collect(&:email).join(",")
  end

  column :student_1_email, if: ->(grid) { grid.admin }  do
    team.students.first&.email
  end

  column :student_2_email, if: ->(grid) { grid.admin }  do
    team.students.second&.email
  end

  column :student_3_email, if: ->(grid) { grid.admin }  do
    team.students.third&.email
  end

  column :student_4_email, if: ->(grid) { grid.admin }  do
    team.students.fourth&.email
  end

  column :student_5_email, if: ->(grid) { grid.admin }  do
    team.students.fifth&.email
  end

  column :parent_names do
    team.students.collect(&:parent_guardian_name).join(",")
  end

  column :student_1_parent, if: ->(grid) { grid.admin }  do
    team.students.first&.parent_guardian_name
  end

  column :student_2_parent, if: ->(grid) { grid.admin }  do
    team.students.second&.parent_guardian_name
  end

  column :student_3_parent, if: ->(grid) { grid.admin }  do
    team.students.third&.parent_guardian_name
  end

  column :student_4_parent, if: ->(grid) { grid.admin }  do
    team.students.fourth&.parent_guardian_name
  end

  column :student_5_parent, if: ->(grid) { grid.admin }  do
    team.students.fifth&.parent_guardian_name
  end

  column :parent_emails do
    team.students.collect(&:parent_guardian_email).join(",")
  end

  column :student_1_parent_email, if: ->(grid) { grid.admin }  do
    team.students.first&.parent_guardian_email
  end

  column :student_2_parent_email, if: ->(grid) { grid.admin }  do
    team.students.second&.parent_guardian_email
  end

  column :student_3_parent_email, if: ->(grid) { grid.admin }  do
    team.students.third&.parent_guardian_email
  end

  column :student_4_parent_email, if: ->(grid) { grid.admin }  do
    team.students.fourth&.parent_guardian_email
  end

  column :student_5_parent_email, if: ->(grid) { grid.admin }  do
    team.students.fifth&.parent_guardian_email
  end

  column :mentor_names do
    team.mentors.collect(&:name).join(",")
  end

  column :mentor_emails do
    team.mentors.collect(&:email).join(",")
  end

  column :ai_question, header: "AI question", if: ->(grid) { grid.admin } do
    if ai?
      "Yes - #{ai_description}"
    elsif ai == false
      "No"
    elsif ai.nil?
      "-"
    end
  end

  column :climate_change_question, if: ->(grid) { grid.admin } do
    if climate_change?
      "Yes - #{climate_change_description}"
    elsif climate_change == false
      "No"
    elsif climate_change.nil?
      "-"
    end
  end

  column :game_question, if: ->(grid) { grid.admin } do
    if game?
      "Yes - #{game_description}"
    elsif game == false
      "No"
    elsif game.nil?
      "-"
    end
  end

  filter :round,
  :enum,
  select: -> { [
    ["Quarterfinals", "quarterfinals"],
    ["Semifinals", "semifinals"]
  ] } do |value, scope, grid|
    mod = grid.complete.present? ? grid.complete : "all"
    assoc = "#{value}_#{mod}_submission_scores".to_sym
    scope.joins(assoc)
  end

  filter :division,
  :enum,
  select: -> { [
    ["Senior", "senior"],
    ["Junior", "junior"]
  ]} do |value, scope, grid|
    scope.public_send(value)
  end

  filter :by_event,
    :enum,
    select: ->(grid) {
      RegionalPitchEvent.visible_to(grid.current_account)
        .current
        .order(:name)
        .map { |e| [e.name, e.id] }
    },
    if: ->(g) { g.admin or RegionalPitchEvent.visible_to(g.current_account).any? } do |value, scope, grid|
      scope.includes(team: :events)
        .references(:regional_pitch_events)
        .where("regional_pitch_events.id = ?", value)
  end

  filter :team_or_submission_name do |value|
    where(
      "lower(trim(teams.name)) ILIKE ? OR " +
      "lower(trim(team_submissions.app_name)) ILIKE ?",
      "#{value.downcase.strip}%",
      "#{value.downcase.strip}%"
    )
  end

  filter :live_or_virtual,
    :enum,
    select: [
      ["Virtual scores", "virtual"],
      ["Live event scores", "live"]
    ],
    filter_group: "common" do |value, scope, grid|
      mod = grid.complete.present? ? grid.complete : "all"
      assoc = "#{value}_#{mod}_submission_scores".to_sym
      scope.joins(assoc)
  end

  filter :submission_contest_rank,
    :enum,
    select: TeamSubmission.contest_ranks.keys,
    filter_group: "common" do |value, scope, grid|
      scope.public_send(value)
  end

  filter :complete,
  :enum,
  select: [
    ["Complete scores", "complete"],
    ["Incomplete scores", "incomplete"]
  ] do |value, scope, grid|
    scope.joins("#{grid.round}_#{value}_submission_scores".to_sym)
  end

  filter :country,
    :enum,
    header: "Country",
    select: ->(g) {
      CountryStateSelect.countries_collection
    },
    filter_group: "more-specific",
    multiple: true,
    data: {
      placeholder: "Select or start typing..."
    },
    if: ->(g) { g.admin } do |values|
      clauses = values.flatten.map { |v| "teams.country = '#{v}'" }
      where(clauses.join(' OR '))
    end

  filter :state_province,
    :enum,
    header: "State / Province",
    select: ->(g) {
      CS.get(g.country[0]).map { |s| [s[1], s[0]] }
    },
    filter_group: "more-specific",
    multiple: true,
    data: {
      placeholder: "Select or start typing...",
    },
    if: ->(grid) { GridCanFilterByState.(grid) } do |values, scope, grid|
      scope.where("teams.country = ?", grid.country)
        .where(
          StateClauses.for(
            values: values,
            countries: grid.country,
            table_name: "teams",
            operator: "OR"
          )
        )
    end

  filter :city,
    :enum,
    select: ->(g) {
      country = g.country[0]
      state = g.state_province[0]
      CS.get(country, state)
    },
    filter_group: "more-specific",
    multiple: true,
    data: {
      placeholder: "Select or start typing...",
    },
    if: ->(grid) { GridCanFilterByCity.(grid) } do |values, scope, grid|
      scope.where(
        StateClauses.for(
          values: grid.state_province,
          countries: grid.country,
          table_name: "teams",
          operator: "OR"
        )
      )
        .where(
          CityClauses.for(
            values: values,
            table_name: "teams",
            operator: "OR"
          )
        )
    end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
