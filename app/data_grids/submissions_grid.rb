class SubmissionsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    TeamSubmission.includes(:screenshots, team: :division).references(:teams)
  end

  column :submission_id, header: "Submission ID", if: ->(grid) { grid.admin } do
    id
  end

  column :division, mandatory: true do
    team.division_name.humanize
  end

  column :seasons do
    seasons.to_sentence
  end

  column :contest_rank, if: ->(g) { g.admin } do |submission|
    submission.contest_rank.humanize.titleize
  end

  column :project_name, mandatory: true, html: true, order: "team_submissions.app_name" do |sub|
    link_to sub.app_name, send(:"#{current_scope}_team_submission_path", sub)
  end

  column :project_description do
    app_description
  end

  column :demo_video_link, header: "#{I18n.t("submissions.demo_video").upcase_first} link", order: false
  column :learning_journey, order: false
  column :information_legitimacy_description, order: false
  column :pitch_video_link, order: false
  column :submission_type
  column :thunkable_project_url

  column :images do
    screenshots.count
  end

  column :app_inventor_app_name
  column :source_code_url

  column :business_plan_url do
    team.senior? ? business_plan_url : "-"
  end

  column :adoption_plan_url do
    team.junior? ? business_plan_url : "-"
  end

  column :pitch_presentation_url

  column :team_id, header: "Team ID", if: ->(grid) { grid.admin } do
    team.id
  end

  column :team_name,
    mandatory: true,
    order: "teams.name",
    html: true do |sub|
    link_to sub.team_name, send(:"#{current_scope}_team_path", sub.team)
  end

  column :team_name, html: false

  column :project_name, html: false do
    app_name
  end

  column :project_page,
    mandatory: true,
    html: true do |sub|
    link_to(
      "#{request.base_url}#{project_path(sub)}",
      project_path(sub),
      target: :_blank,
      data: {turbolinks: false}
    )
  end

  column :project_page, html: false do |submission|
    Rails.application.routes.url_helpers.url_for(controller: "projects", action: "show", id: submission)
  end

  column :ai, header: "Uses AI", if: ->(grid) { grid.admin } do
    description = ai? ? " - #{ai_description}" : ""

    ApplicationController.helpers
      .humanize_boolean(ai)
      .concat(description)
  end

  column :climate_change, header: "Helps solve climate change", if: ->(grid) { grid.admin } do
    description = climate_change? ? " - #{climate_change_description}" : ""

    ApplicationController.helpers
      .humanize_boolean(climate_change)
      .concat(description)
  end

  column :game, header: "Is a game", if: ->(grid) { grid.admin } do
    description = game? ? " - #{game_description}" : ""

    ApplicationController.helpers
      .humanize_boolean(game)
      .concat(description)
  end

  column :solves_health_problem, if: ->(grid) { grid.admin } do
    description = solves_health_problem? ? " - #{solves_health_problem_description}" : ""

    ApplicationController.helpers
      .humanize_boolean(solves_health_problem)
      .concat(description)
  end

  column :solves_education, if: ->(grid) { grid.admin } do
    description = solves_education? ? " - #{solves_education_description}" : ""

    ApplicationController.helpers
      .humanize_boolean(solves_education)
      .concat(description)
  end

  column :solves_hunger_or_food_waste, if: ->(grid) { grid.admin } do
    description = solves_hunger_or_food_waste? ? " - #{solves_hunger_or_food_waste_description}" : ""

    ApplicationController.helpers
      .humanize_boolean(solves_hunger_or_food_waste)
      .concat(description)
  end

  column :uses_open_ai, header: "Uses OpenAI/ChatGPT", if: ->(grid) { grid.admin } do
    description = uses_open_ai? ? " - #{uses_open_ai_description}" : ""

    ApplicationController.helpers
      .humanize_boolean(uses_open_ai)
      .concat(description)
  end

  column :uses_gadgets, header: "Uses Gadgets", if: ->(grid) { grid.admin } do
    description = uses_gadgets? ? " - #{team_submission_gadget_types.joins(:gadget_type).pluck(:name).join(", ")}" : ""

    ApplicationController.helpers
      .humanize_boolean(uses_gadgets)
      .concat(description)
  end

  column :city, order: "teams.city" do
    team.city
  end

  column :development_platform do
    development_platform_text.presence || "-"
  end

  column :state_province, header: "State", order: "teams.state_province" do
    FriendlySubregion.call(team, prefix: false)
  end

  column :country, order: "teams.country" do
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

  column :submitted?, order: :published_at do
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

  column :student_names do
    team.students.collect(&:name).join(",")
  end

  column :student_1_name, if: ->(grid) { grid.admin } do
    team.students.first&.name
  end

  column :student_2_name, if: ->(grid) { grid.admin } do
    team.students.second&.name
  end

  column :student_3_name, if: ->(grid) { grid.admin } do
    team.students.third&.name
  end

  column :student_4_name, if: ->(grid) { grid.admin } do
    team.students.fourth&.name
  end

  column :student_5_name, if: ->(grid) { grid.admin } do
    team.students.fifth&.name
  end

  column :student_emails do
    team.students.collect(&:email).join(",")
  end

  column :student_1_email, if: ->(grid) { grid.admin } do
    team.students.first&.email
  end

  column :student_2_email, if: ->(grid) { grid.admin } do
    team.students.second&.email
  end

  column :student_3_email, if: ->(grid) { grid.admin } do
    team.students.third&.email
  end

  column :student_4_email, if: ->(grid) { grid.admin } do
    team.students.fourth&.email
  end

  column :student_5_email, if: ->(grid) { grid.admin } do
    team.students.fifth&.email
  end

  column :parent_names do
    team.students.collect(&:parent_guardian_name).join(",")
  end

  column :student_1_parent, if: ->(grid) { grid.admin } do
    team.students.first&.parent_guardian_name
  end

  column :student_2_parent, if: ->(grid) { grid.admin } do
    team.students.second&.parent_guardian_name
  end

  column :student_3_parent, if: ->(grid) { grid.admin } do
    team.students.third&.parent_guardian_name
  end

  column :student_4_parent, if: ->(grid) { grid.admin } do
    team.students.fourth&.parent_guardian_name
  end

  column :student_5_parent, if: ->(grid) { grid.admin } do
    team.students.fifth&.parent_guardian_name
  end

  column :parent_emails do
    team.students.collect(&:parent_guardian_email).join(",")
  end

  column :student_1_parent_email, if: ->(grid) { grid.admin } do
    team.students.first&.parent_guardian_email
  end

  column :student_2_parent_email, if: ->(grid) { grid.admin } do
    team.students.second&.parent_guardian_email
  end

  column :student_3_parent_email, if: ->(grid) { grid.admin } do
    team.students.third&.parent_guardian_email
  end

  column :student_4_parent_email, if: ->(grid) { grid.admin } do
    team.students.fourth&.parent_guardian_email
  end

  column :student_5_parent_email, if: ->(grid) { grid.admin } do
    team.students.fifth&.parent_guardian_email
  end

  column :number_of_mentors do
    team.mentors.count
  end

  column :mentor_names do
    team.mentors.collect(&:name).join(",")
  end

  column :mentor_emails do
    team.mentors.collect(&:email).join(",")
  end

  filter :team_name do |value, scope|
    processed_value = I18n.transliterate(value.strip.downcase).gsub(/['\s]+/, "%")
    scope
      .where("lower(unaccent(teams.name)) ILIKE ?", "%#{processed_value}%")
  end

  filter :app_name do |value, scope, grid|
    processed_value = I18n.transliterate(value.strip.downcase).gsub(/['\s]+/, "%")
    scope
      .where("lower(unaccent(team_submissions.app_name)) ILIKE ?", "%#{processed_value}%")
  end

  filter :division,
    :enum,
    select: [["Senior", "senior"], ["Junior", "junior"], ["Beginner", "beginner"]] do |value|
      where(
        "teams.division_id = ?",
        Division.send(value).id
      )
    end

  filter :contest_rank,
    :enum,
    if: ->(g) { g.admin },
    select: TeamSubmission.contest_ranks.map { |key, _value| [key.humanize.titleize, key] } do |value|
      public_send(value)
    end

  filter :live_virtual,
    :enum,
    header: "Live event or virtual judging",
    filter_group: "more-specific",
    select: [
      ["Live, official event submissions", "live"],
      ["Virtual submissions", "virtual"]
    ] do |value|
    public_send(value)
  end

  filter :submitted,
    :enum,
    filter_group: "more-specific",
    select: [
      ["Yes, submitted", "complete"],
      ["No, unsubmitted", "incomplete"]
    ] do |value|
      send(value)
    end

  filter :qualified,
    :enum,
    filter_group: "more-specific",
    header: "Team Qualified?",
    select: [
      ["Yes, qualified", true],
      ["No, not qualified", false]
    ] do |value|
    operator = (value == "true") ? "AND" : "OR"
    where("teams.has_students = ? #{operator} teams.all_students_onboarded = ?", value, value)
  end

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
    filter_group: "more-specific",
    html: {
      class: "and-or-field"
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
      placeholder: "Select or start typing..."
    },
    if: ->(g) { g.admin } do |values|
      clauses = values.flatten.map { |v| "teams.country = '#{v}'" }
      where(clauses.join(" OR "))
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
      placeholder: "Select or start typing..."
    },
    if: ->(grid) { GridCanFilterByState.call(grid) } do |values, scope, grid|
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
      placeholder: "Select or start typing..."
    },
    if: ->(grid) { GridCanFilterByCity.call(grid) } do |values, scope, grid|
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

  filter :chapter,
    :enum,
    header: "Chapter",
    select: Chapter.all.order(name: :asc).map { |c| [c.name, c.id] },
    filter_group: "more-specific",
    if: ->(g) {
      g.admin
    },
    data: {
      placeholder: "Select a chapter"
    } do |value, scope, grid|
      scope.by_chapterable("Chapter", value, grid.season).distinct
    end

  filter :club,
    :enum,
    header: "Club",
    select: Club.all.order(name: :asc).map { |c| [c.name, c.id] },
    filter_group: "more-specific",
    if: ->(g) {
      g.admin
    },
    data: {
      placeholder: "Select a club"
    } do |value, scope, grid|
      scope.by_chapterable("Club", value, grid.season).distinct
  end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
