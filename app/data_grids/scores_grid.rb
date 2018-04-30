class ScoresGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    SubmissionScore.current
      .includes({ team_submission: :team }, :judge_profile)
      .references(:teams, :team_submissions, :judge_profiles)
  end

  column :division do
    team_submission.team_division_name
  end

  column :judge, html: true do |score|
    link_to score.judge_profile.name,
     [current_scope, :participant, id: score.judge_profile.account_id]
  end

  column :round
  column :total
  column :total_possible

  filter :by_event,
    :enum,
    select: RegionalPitchEvent.current.order(:name).map { |e|
      [e.name, e.id]
    } do |value, scope, grid|
      scope.includes(judge_profile: :events)
        .references(:regional_pitch_events)
        .where("regional_pitch_events.id = ?", value)
  end


  filter :live_or_virtual,
    :enum,
    select: [
      ['Virtual scores', 'virtual'],
      ['Live event scores', 'live'],
    ],
    filter_group: "common" do |value|
      send(value)
    end

  filter :complete,
  :enum,
  select: [
    ["Complete scores", "complete"],
    ["Incomplete scores", "incomplete"],
  ] do |value|
    send(value)
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