class ClubAmbassadorsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    Account
      .includes(:club_ambassador_profile, :chapterable_assignments, :clubs)
      .where.not(club_ambassador_profiles: {id: nil})
      .order(id: :desc)
  end

  column :name, header: "Club Name", mandatory: true do |account|
    if account.assigned_to_club?
      format(account.current_primary_club.name) do
        link_to(
          account.current_primary_club.name || "-",
          admin_club_path(account.current_primary_club)
        )
      end
    else
      "No club"
    end
  end

  column :first_name, mandatory: true
  column :last_name, mandatory: true
  column :email, mandatory: true
  column :id, header: "Participant ID"

  column :seasons do |account|
    account.seasons.join(", ")
  end

  column :gender, header: "Gender Identity" do
    gender.presence || "-"
  end

  column :phone_number do
    club_ambassador_profile.phone_number.presence || "-"
  end

  column :city

  column :state_province, header: "State" do
    FriendlySubregion.call(self, prefix: false)
  end

  column :country do
    FriendlyCountry.new(self).country_name
  end

  column :actions, mandatory: true, html: true do |account|
    link_to(
      "view",
      send(:"#{current_scope}_participant_path", account),
      data: {turbolinks: false}
    )
  end

  filter :has_mentor_profile,
    :enum,
    select: [
      ["Yes, is also a mentor", "yes"],
      ["No", "no"]
    ],
    filter_group: "common" do |value, scope, grid|
      is_is_not = (value === "yes") ? "IS NOT" : "IS"

      scope.left_outer_joins(:mentor_profile).where(
        "mentor_profiles.id #{is_is_not} NULL"
      )
    end

  filter :assigned_to_club,
    :enum,
    header: "Assigned to Club (only applies to current season)",
    select: [
      ["Yes", "yes"],
      ["No", "no"]
    ],
    filter_group: "common" do |value, scope, grid|
      if value == "yes"
        scope
          .joins(:chapterable_assignments)
          .where(chapterable_assignments: {season: Season.current.year})
      else
        scope
      end
    end

  filter :club_status,
    :enum,
    header: "Club Status (only applies to current season)",
    select: [
      ["Active"],
      ["Inactive"]
    ],
    filter_group: "common" do |value, scope, grid|
      if value == "Active"
        scope
          .where("'#{Season.current.year}' = ANY (clubs.seasons)")
      else
        scope
          .where.not("'#{Season.current.year}' = ANY (clubs.seasons)")
      end
    end

  filter :onboarded,
    :enum,
    header: "Onboarded (includes Club onboarding)",
    select: [
      ["Yes, fully onboarded", true],
      ["No, still onboarding", false]
    ],
    filter_group: "common" do |value, scope, grid|
      if value == "true"
        scope
          .where(club_ambassador_profiles: {onboarded: true})
          .where(clubs: {onboarded: true})
      else
        scope
          .where(club_ambassador_profiles: {onboarded: false})
          .or(scope.where(clubs: {onboarded: false}))
      end
    end

  filter :season,
    :enum,
    select: (2025..Season.current.year).to_a.reverse,
    html: {
      class: "and-or-field"
    },
    multiple: true do |value, scope, grid|
    scope.by_season(value)
  end

  filter :name_email,
    header: "Name or Email",
    filter_group: "common" do |value, scope, grid|
      names = value.strip.downcase.split(" ").map { |n|
        I18n.transliterate(n).gsub("'", "''")
      }
      scope.fuzzy_search({
        first_name: names.first,
        last_name: names.last || names.first,
        email: names.first
      }, false)
        .left_outer_joins(:club_ambassador_profile)
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
      scope.where(country: grid.country)
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
        values: grid.state_province[0],
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

  filter :club_name do |value, scope|
    processed_value = I18n.transliterate(value.strip.downcase).gsub(/['\s]+/, "%")
    scope
      .left_outer_joins(:club_ambassador_profile)
      .left_outer_joins(:chapterable_assignments)
      .left_outer_joins(:clubs)
      .where("lower(unaccent(clubs.name)) ILIKE ?", "%#{processed_value}%")
  end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
