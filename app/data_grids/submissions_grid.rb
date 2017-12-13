class SubmissionsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    TeamSubmission.includes(:team).references(:teams)
  end

  column :team_name, mandatory: true
  column :app_name, mandatory: true
  column :state_province, header: "State"

  column :country, mandatory: true do
    if found_country = Carmen::Country.coded(country)
      found_country.name
    end
  end

  column :actions, mandatory: true, html: true do |submission|
    link_to(
      "edit",
      send("admin_team_submissions_path", submission),
      data: { turbolinks: false }
    )
  end

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
    filter_group: "more-specific",
    html: {
      class: "and-or-field",
    },
    multiple: true do |value|
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
end
