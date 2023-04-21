class TeamsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    Team
  end

  column :id, header: "Team ID", if: ->(g) { g.admin }

  column :name, mandatory: true

  column :division, mandatory: true do
    division.name.humanize
  end

  column :event_name do
    event.name
  end

  column :mentor_matched, header: "Has mentor?" do
    has_mentor? ? "yes" : "no"
  end

  column :student_matched, header: "Has students?" do
    has_students? ? "yes" : "no"
  end

  column :number_of_students, header: "Number of students" do
    students.length
  end

  column :student_ids, header: "Student Ids", if: ->(grid) { grid.admin } do
    students.collect { |s| s.account.id }.join(",")
  end

  column :student_names do
    students.collect(&:name).join(",")
  end

  column :student_1_name, if: ->(grid) { grid.admin } do
    students.first&.name
  end

  column :student_2_name, if: ->(grid) { grid.admin } do
    students.second&.name
  end

  column :student_3_name, if: ->(grid) { grid.admin } do
    students.third&.name
  end

  column :student_4_name, if: ->(grid) { grid.admin } do
    students.fourth&.name
  end

  column :student_5_name, if: ->(grid) { grid.admin } do
    students.fifth&.name
  end

  column :student_emails do
    students.collect(&:email).join(",")
  end

  column :student_1_email, if: ->(grid) { grid.admin } do
    students.first&.email
  end

  column :student_2_email, if: ->(grid) { grid.admin } do
    students.second&.email
  end

  column :student_3_email, if: ->(grid) { grid.admin } do
    students.third&.email
  end

  column :student_4_email, if: ->(grid) { grid.admin } do
    students.fourth&.email
  end

  column :student_5_email, if: ->(grid) { grid.admin } do
    students.fifth&.email
  end

  column :parent_names do
    students.collect(&:parent_guardian_name).join(",")
  end

  column :student_1_parent, if: ->(grid) { grid.admin } do
    students.first&.parent_guardian_name
  end

  column :student_2_parent, if: ->(grid) { grid.admin } do
    students.second&.parent_guardian_name
  end

  column :student_3_parent, if: ->(grid) { grid.admin } do
    students.third&.parent_guardian_name
  end

  column :student_4_parent, if: ->(grid) { grid.admin } do
    students.fourth&.parent_guardian_name
  end

  column :student_5_parent, if: ->(grid) { grid.admin } do
    students.fifth&.parent_guardian_name
  end

  column :parent_emails do
    students.collect(&:parent_guardian_email).join(",")
  end

  column :student_1_parent_email, if: ->(grid) { grid.admin } do
    students.first&.parent_guardian_email
  end

  column :student_2_parent_email, if: ->(grid) { grid.admin } do
    students.second&.parent_guardian_email
  end

  column :student_3_parent_email, if: ->(grid) { grid.admin } do
    students.third&.parent_guardian_email
  end

  column :student_4_parent_email, if: ->(grid) { grid.admin } do
    students.fourth&.parent_guardian_email
  end

  column :student_5_parent_email, if: ->(grid) { grid.admin } do
    students.fifth&.parent_guardian_email
  end

  column :number_of_mentors, header: "Number of mentors" do
    mentors.length
  end

  column :mentor_ids, header: "Mentor Ids", if: ->(grid) { grid.admin } do
    mentors.collect { |m| m.account.id }.join(",")
  end

  column :mentor_names do
    mentors.collect(&:name).join(",")
  end

  column :mentor_emails do
    mentors.collect(&:email).join(",")
  end

  column :city

  column :state_province, header: "State" do
    FriendlySubregion.(self, prefix: false)
  end

  column :country do
    FriendlyCountry.new(self).country_name
  end

  column :created_at, header: "Created" do
    created_at.strftime("%Y-%m-%d")
  end

  column :actions, mandatory: true, html: true do |account|
    link_to(
      "view",
      send("#{current_scope}_team_path", account),
      data: { turbolinks: false }
    )
  end

  column :qualified do
    all_students_onboarded? ? "yes" : "NO"
  end

  filter :division,
    :enum,
    header: "Division",
    select: Division.names.keys.map { |n|
      [n.humanize, n]
    },
    filter_group: "common" do |value|
    by_division(value)
  end

  filter :mentor_match,
    :enum,
    header: "Has a mentor?",
    select: [["Yes, has a mentor", "yes"],
             ["No mentor matched yet", "no"]],
    filter_group: "common" do |value|
    if value == "yes"
      matched(:mentor)
    else
      unmatched(:mentor)
    end
  end

  filter :student_match,
    :enum,
    header: "Has students?",
    select: [["Yes, has students", "yes"],
             ["No students matched yet", "no"]],
    filter_group: "common" do |value|
    if value == "yes"
      matched(:students)
    else
      unmatched(:students)
    end
  end

  filter :qualified,
    :enum,
    header: "All students onboarded?",
    select: [["Yes, students are onboarded", "all_students_onboarded"],
             ["No, some students are not onboarded", "some_students_onboarding"],
             ["No, there are no students", "no_students"]],
    filter_group: "common" do |value|
      send(value)
  end

  filter :name, filter_group: "more-specific" do |value|
    fuzzy_search(name: value)
  end

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
    filter_group: "more-specific",
    html: {
      class: "and-or-field",
    },
    multiple: false do |value|
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
      scope
        .where(country: grid.country)
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
