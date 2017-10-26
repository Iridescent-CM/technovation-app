class AccountsGrid
  include Datagrid

  attr_accessor :admin

  scope do
    Account.left_outer_joins([
      :student_profile,
      :mentor_profile,
      :judge_profile,
      :regional_ambassador_profile,
    ])
      .order("accounts.created_at desc")
  end

  column :first_name, mandatory: true
  column :last_name, mandatory: true
  column :email, mandatory: true

  column :age, order: "accounts.date_of_birth desc"
  column :city
  column :state_province, header: "State"
  column :country do
    if found_country = Carmen::Country.coded(country)
      found_country.name
    end
  end

  column :created_at, header: "Signed up" do
    created_at.strftime("%Y-%m-%d")
  end

  column :actions, mandatory: true, html: true do |account|
    link_to "view", send("#{current_scope}_participant_path", account)
  end

  filter :name do |value|
    names = value.downcase.split(' ').map { |n| I18n.transliterate(n) }
    where(
      "unaccent(lower(accounts.first_name)) ilike '%#{names.first}%' OR
       unaccent(lower(accounts.last_name)) ilike '%#{names.last}%'"
    )
  end

  filter :email do |value|
    where("accounts.email ilike '%#{value}%'")
  end

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
    multiple: true do |value|
    by_season(value)
  end

  filter :country,
    :enum,
    header: "Country",
    select: ->(g) {
      CountryStateSelect.countries_collection
    },
    multiple: true,
    if: ->(g) { g.admin } do |values|
      clauses = values.map { |v| "accounts.country = '#{v}'" }
      where(clauses.join(' OR '))
    end

  filter :state_province,
    :enum,
    header: "State / Province",
    select: ->(g) { CS.get(g.country[0]).map { |s| [s[1], s[0]] } },
    multiple: true,
    if: ->(g) {
      g.country.one? && CS.get(g.country[0]).any?
    } do |values, scope, grid|
      clauses = values.map { |v| "lower(accounts.state_province) like '#{v.downcase}%'" }

      scope.where(country: grid.country)
        .where(clauses.join(' OR '))
    end

  filter :city,
    :enum,
    select: ->(g) { CS.get(g.country[0], g.state_province[0]) },
    multiple: true,
    if: ->(g) {
      g.state_province.one? && CS.get(g.country[0], g.state_province[0]).any?
    } do |values, scope, grid|
      clauses = values.map { |v| "accounts.city = '#{v}'" }

      scope.where(state_province: grid.state_province[0])
        .where(clauses.join(' OR '))
    end

  filter :scope_names,
    :enum,
    header: "Profile type",
    select: [
      ['Students', 'student'],
      ['Mentors', 'mentor'],
      ['Judges', 'judge'],
      ['Regional Ambassadors', 'regional_ambassador'],
    ],
    multiple: true do |values|
      clauses = values.map { |v| "#{v}_profiles.id IS NOT NULL" }
      where(clauses.join(' AND '))
    end

  filter :team_matching,
    :enum,
    select: [
      ['Matched with a team', 'matched'],
      ['Unmatched', 'unmatched'],
    ],
    if: ->(g) { (%w{judge regional_ambassador} & (g.scope_names || [])).empty? } do |value|
      send(value)
    end

  column_names_filter(header: "More columns", multiple: true)
end
