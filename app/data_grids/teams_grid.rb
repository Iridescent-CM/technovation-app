class TeamsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    Team
  end

  column :name, mandatory: true

  column :division, mandatory: true do
    division.name.humanize
  end

  column :mentor_matched, header: "Has mentor?" do
    has_mentor? ? "yes" : "no"
  end

  column :student_matched, header: "Has students?" do
    has_students? ? "yes" : "no"
  end

  column :city

  column :state_province, header: "State"

  column :country do
    if found_country = Carmen::Country.coded(country)
      found_country.name
    end
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
    if: ->(g) {
      (g.admin or g.allow_state_search) and
        g.country.one? and
          CS.get(g.country[0]).any?
    } do |values, scope, grid|
      clauses = values.flatten.map do |v|
        v = v === "DIF" ? "CDMX" : v
        "lower(teams.state_province) like '#{v.downcase}%'"
      end

      scope.where(country: grid.country)
        .where(clauses.join(' OR '))
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
    if: ->(g) {
      country = g.country[0]
      state = g.state_province[0]
      g.state_province.one? && CS.get(country, state).any?
    } do |values, scope, grid|
      clauses = values.flatten.map do |v|
        v = v === "Mexico City" ? "Ciudad de México" : v
        "unaccent(teams.city) = unaccent('#{v}')"
      end

      state = grid.state_province[0]
      state = state === "DIF" ? "CDMX" : state

      scope.where("lower(teams.state_province) like '#{state.downcase}%'")
        .where(clauses.join(' OR '))
    end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
