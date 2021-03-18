class SubmissionsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    TeamSubmission.includes(:team).references(:teams)
  end

  column :division, mandatory: true do
    team.division_name.humanize
  end

  column :contest_rank, mandatory: true

  column :app_name
  column :app_description
  column :demo_video_link
  column :pitch_video_link

  column :screenshots do
    screenshots.count
  end

  column :development_platform_text
  column :app_inventor_app_name
  column :app_inventor_gmail
  column :source_code_url
  column :business_plan_url
  column :pitch_presentation_url

  column :team_name,
    mandatory: true,
    order: "teams.name",
    html: true do |sub|
    link_to sub.team_name, [current_scope, sub.team]
  end

  column :team_name, html: false

  column :app_name, mandatory: true, html: true do |sub|
    link_to sub.app_name, [current_scope, sub]
  end

  column :app_name, html: false

  column :city, order: "teams.city" do
    team.city
  end

  column :state_province, header: "State" do
    FriendlySubregion.(team, prefix: false)
  end

  column :country do
    FriendlyCountry.new(team).country_name
  end

  column :complete? do
    complete? ? "yes" : "no"
  end

  column :required_fields do |submission|
    RequiredFields.new(submission).all?(&:complete?) ? "Complete" : "Incomplete"
  end

  column :team_qualified? do
    team.qualified? ? "yes" : "no"
  end

  column :submitted? do
    published? ? "yes" : "no"
  end

  column :only_needs_to_submit? do
    only_needs_to_submit? ? "yes" : "no"
  end

  column :progress,
    order: "team_submissions.percent_complete",
    mandatory: true,
    html: true do |submission|
    submission_progress_bar(submission)
  end

  column :progress, html: false do |submission|
    "#{submission.percent_complete}%"
  end

  column :missing_pieces, header: "Missing submission pieces" do |submission|
    ApplicationController.helpers.format_missing_submission_pieces(submission)
  end

  column :number_of_students do
    team.students.count
  end

  column :number_of_mentors do
    team.mentors.count
  end

  column :student_names do
    team.students.map(&:name).to_sentence
  end

  column :mentor_names do
    team.mentors.map(&:name).to_sentence
  end

  filter :team_name do |value, scope, grid|
    scope.where("teams.name ilike ?", "#{value}%")
  end

  filter :app_name do |value, scope, grid|
    scope.where("team_submissions.app_name ilike ?", "#{value}%")
  end

  filter :division,
    :enum,
    select: [["Senior", "senior"], ["Junior", "junior"]] do |value|
      where(
        "teams.division_id = ?",
        Division.send(value).id
      )
  end

  filter :contest_rank,
    :enum,
    select: TeamSubmission.contest_ranks.keys do |value|
      public_send(value)
  end

  filter :live_virtual,
    :enum,
    header: "Live event or virtual judging",
    filter_group: "more-specific",
    select: [
      ["Live, official event submissions", "live"],
      ["Virtual submissions", "virtual"],
    ] do |value|
      public_send(value)
  end

  filter :submitted,
    :enum,
    filter_group: "more-specific",
    select: [
      ["Yes, submitted", "complete"],
      ["No, unsubmitted", "incomplete"],
    ] do |value|
      send(value)
    end

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
    filter_group: "more-specific",
    html: {
      class: "and-or-field",
    } do |value|
    by_season(value)
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
