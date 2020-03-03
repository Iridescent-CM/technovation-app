class EventsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    RegionalPitchEvent.current
      .includes(ambassador: :account)
      .references(:accounts)
  end

  column :ambassador_name,
    header: "Ambassador",
    mandatory: true

  column :name, mandatory: true

  column :divisions, mandatory: true do
    division_names
  end

  column :official, mandatory: true do
    unofficial? ? "unofficial" : "official"
  end

  column :date

  column :time

  column :city

  column :state_province, header: "State" do
    FriendlySubregion.(self, prefix: false)
  end

  column :country do
    Carmen::Country.coded(country) || Carmen::Country.named(country)
  end

  column :judge_count do
    judge_list.size
  end

  column :teams_count, header: "Team count", mandatory: true

  column :actions, mandatory: true, html: true do |event|
    link_to "view", admin_event_path(event)
  end

  column :created_at do
    created_at.strftime("%Y-%m-%d %H:%M %Z")
  end

  column :updated_at, header: "Last updated at" do
    updated_at.strftime("%Y-%m-%d %H:%M %Z")
  end

  filter :ambassador_name do |value|
    names = value.split(" ")
    first_name = names.first
    last_name = names.last

    where("accounts.first_name ilike ? OR " +
          "accounts.last_name ilike ? ",
          "#{first_name}%", "#{last_name}%")
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

  filter :official,
    :enum,
    select:["official", "unofficial"] do |value|
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
      clauses = values.flatten.map { |v| "accounts.country = '#{v}'" }
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
        .where({ "accounts.country" => grid.country })
        .where(
          StateClauses.for(
            values: values,
            countries: grid.country,
            table_name: "accounts",
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
          table_name: "accounts",
          operator: "OR"
        )
      )
        .where(
          CityClauses.for(
            values: values,
            table_name: "accounts",
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