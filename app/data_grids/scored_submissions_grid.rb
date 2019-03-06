class ScoredSubmissionsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search, :current_account

  self.batch_size = 10

  scope do
    TeamSubmission.complete.current
      .includes(:team, { submission_scores: :judge_profile })
      .references(:teams, :submission_scores, :judge_profiles)
  end

  column :contest_rank, mandatory: true, html: false

  column :contest_rank, mandatory: true, html: true, if: ->(g) { g.admin } do |asset, grid|
    select_tag(
      :contest_rank,
      options_from_collection_for_select(
        TeamSubmission.contest_ranks,
        :first,
        :first,
        asset.contest_rank,
      ),
      "v-on:change" => "updateContestRank",
      data: { submission_id: asset.id },
    )
  end

  column :division do
    team_division_name
  end

  column :team_name, mandatory: true, html: false
  column :team_name, mandatory: true, html: true do |submission|
    link_to submission.team_name,
      [current_scope, submission.team, allow_out_of_region: true],
      data: { turbolinks: false }
  end

  column :app_name, mandatory: true, html: false
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

  filter :round,
  :enum,
  select: -> { [
    ['Quarterfinals', 'quarterfinals'],
    ['Semifinals', 'semifinals'],
  ] } do |value, scope, grid|
    mod = grid.complete.present? ? grid.complete : "all"
    assoc = "#{value}_#{mod}_submission_scores".to_sym
    scope.joins(assoc)
  end

  filter :division,
  :enum,
  select: -> { [
    ['Senior', 'senior'],
    ['Junior', 'junior'],
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
      ['Virtual scores', 'virtual'],
      ['Live event scores', 'live'],
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
    ["Incomplete scores", "incomplete"],
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
      placeholder: "Select or start typing...",
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