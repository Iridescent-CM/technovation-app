class TeamsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  scope do
    Team.order("teams.created_at desc")
  end

  column :name, mandatory: true

  column :division, mandatory: true do
    division.name.humanize
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

  filter :name, filter_group: "text-search"

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
    filter_group: "and-or",
    multiple: true do |value|
    by_season(value)
  end

  filter :division,
    :enum,
    header: "Division",
    select: Division.names.keys.map { |n|
      [n.humanize, n]
    },
    filter_group: "and-or" do |value|
    by_division(value)
  end

  filter :country,
    :enum,
    header: "Country",
    select: ->(g) {
      CountryStateSelect.countries_collection
    },
    filter_group: "location-data",
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
    filter_group: "location-data",
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
    filter_group: "location-data",
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
        "teams.city = '#{v}'"
      end

      state = grid.state_province[0]
      state = state === "DIF" ? "CDMX" : state

      scope.where(state_province: state)
        .where(clauses.join(' OR '))
    end

  column_names_filter(
    header: "More columns",
    filter_group: "location-data",
    multiple: true
  )
end
