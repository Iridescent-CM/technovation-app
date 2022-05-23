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

  column :project_name, mandatory: true, html: true do |sub|
    link_to sub.app_name, send("#{current_scope}_team_submission_path", sub)
  end
  
  column :project_description do
    app_description
  end

  column :demo_video_link
  column :learning_journey
  column :pitch_video_link
  column :submission_type
  column :thunkable_project_url

  column :images do
    screenshots.count
  end

  column :app_inventor_app_name
  column :app_inventor_gmail
  column :source_code_url
  
  column :business_plan_url do
    team.senior? ? self.business_plan_url : "-"
  end

  column :adoption_plan_url do
    team.junior? ? self.business_plan_url : "-"
  end

  column :pitch_presentation_url

  column :team_name,
    mandatory: true,
    order: "teams.name",
    html: true do |sub|
    link_to sub.team_name, send("#{current_scope}_team_path", sub.team)
  end

  column :team_name, html: false

  column :project_name, html: false do
    app_name
  end

  column :project_page,
    mandatory: true,
    order: "teams.name",
    html: true do |sub|
    link_to(
        "#{request.base_url}#{project_path(sub)}",
        project_path(sub),
        target: :_blank,
        data: { turbolinks: false }
    )
  end

  column :project_page, html: false do |submission|
    Rails.application.routes.url_helpers.url_for(controller: "projects", action: "show", id: submission)
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

  column :city, order: "teams.city" do
    team.city
  end

  column :development_platform do
    if development_platform_text.present?
      platform = development_platform_text 
      platform.downcase.starts_with?("mobile") ? platform : ""
    end  
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

  filter :team_name do |value, scope, grid|
    scope.where("teams.name ilike ?", "#{value}%")
  end

  filter :app_name do |value, scope, grid|
    scope.where("team_submissions.app_name ilike ?", "#{value}%")
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
    select: TeamSubmission.contest_ranks.keys do |value|
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
      placeholder: "Select or start typing..."
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
