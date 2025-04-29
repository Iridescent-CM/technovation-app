class EventsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    RegionalPitchEvent.current
      .includes(:divisions, ambassador: :account)
      .references(:accounts)
  end

  column :ambassador_name,
    header: "Ambassador",
    mandatory: true, order: "accounts.first_name"

  column :name, mandatory: true

  column :chapter, mandatory: true,
    order: ->(scope) { scope.left_joins(ambassador: {account: :chapters}).order("chapters.name") } do |event|
    event.ambassador.account.current_chapter&.name.presence || "-"
  end

  column :divisions, mandatory: true, order: "divisions.name DESC" do
    division_names
  end

  column :official, mandatory: true do
    unofficial? ? "unofficial" : "official"
  end

  column :date, order: "regional_pitch_events.starts_at"

  column :time

  column :city

  column :state_province, header: "State" do
    FriendlySubregion.call(self, prefix: false)
  end

  column :country, order: :country do
    Carmen::Country.coded(country) || Carmen::Country.named(country)
  end

  column :judges, preload: [:judges, :user_invitations] do
    judge_list
      .map { |j| j.account.full_name }
      .join(",")
  end

  column :judge_count do
    judge_list.size
  end

  column :teams, preload: [:teams] do
    teams
      .map(&:name)
      .join(",")
  end

  column :teams_count, header: "Team count", mandatory: true

  column :actions, mandatory: true, html: true do |event|
    link_to "view",
      send(:"#{current_scope}_event_path",
        event)
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

    where("accounts.first_name ilike ? OR " \
          "accounts.last_name ilike ? ",
      "#{first_name}%", "#{last_name}%")
  end

  filter :team_name do |value, scope|
    scope
      .joins(:teams)
      .where("teams.name ilike ? ", "#{value}%")
  end

  filter :judge_name do |value, scope|
    full_name = value.split(" ")
    first_name = I18n.transliterate(full_name.first.strip.downcase).gsub(/['\s]+/, "%")
    last_name = I18n.transliterate(full_name.last.strip.downcase).gsub(/['\s]+/, "%")

    scope
      .joins(judges: :account)
      .where(
        "lower(trim(unaccent(accounts_judge_profiles.first_name))) ILIKE ? OR " \
        "lower(trim(unaccent(accounts_judge_profiles.last_name))) ILIKE ?",
        "%#{first_name}%",
        "%#{last_name}%"
      )
  end

  filter :chapter,
    :enum,
    select: Chapter.all.order(name: :asc).map { |c| [c.name, c.id] },
    filter_group: "common",
    if: ->(g) { g.admin },
    html: {
      class: "and-or-field"
    } do |value|
    by_chapter(value)
  end

  filter :event_name do |value, scope|
    processed_value = I18n.transliterate(value.strip.downcase).gsub(/['\s]+/, "%")
    scope.where("lower(unaccent(regional_pitch_events.name)) ILIKE ?", "%#{processed_value}%")
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
    select: ["official", "unofficial"] do |value|
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
      placeholder: "Select or start typing..."
    },
    if: ->(g) { g.admin } do |values|
      clauses = values.flatten.map { |v| "accounts.country = '#{v}'" }
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
    scope
      .where({"accounts.country" => grid.country})
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
      placeholder: "Select or start typing..."
    },
    if: ->(grid) { GridCanFilterByCity.call(grid) } do |values, scope, grid|
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
