class AccountsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    Account.left_outer_joins([
      :student_profile,
      :mentor_profile,
      :judge_profile,
      :regional_ambassador_profile,
    ])
  end

  column :profile_type do
    scope_name
  end

  column :first_name, mandatory: true
  column :last_name, mandatory: true
  column :email, mandatory: true

  column :parent_guardian_name do
    if student_profile.present?
      student_profile.parent_guardian_name
    else
      "-"
    end
  end

  column :parent_guardian_email do
    if student_profile.present?
      student_profile.parent_guardian_email
    else
      "-"
    end
  end

  column :school_name, order: "student_profiles.school_name" do
    if student_profile.present?
      student_profile.school_name
    else
      "-"
    end
  end

  column :company_name, order: "regional_ambassador_profiles.organization_company_name, mentor_profiles.school_company_name, judge_profiles.company_name" do
    if student_profile.present?
      "-"
    elsif regional_ambassador_profile.present?
      regional_ambassador_profile.organization_company_name
    elsif mentor_profile.present?
      mentor_profile.school_company_name
    else
      judge_profile.company_name
    end
  end

  column :team_division do
    if student_profile.present?
      Division.for(self).name.humanize
    else
      "-"
    end
  end

  column :background_check, if: ->(g) { g.admin or Array(g.country)[0] == "US" } do
    if country == "US" and mentor_profile.present?
      background_check.present? ? background_check.status : "not submitted"
    elsif mentor_profile.present?
      "-"
    else
      "-"
    end
  end

  column :parental_consent do |account, grid|
    if account.student_profile.present?
      account.parental_consent(grid.season).status
    else
      "-"
    end
  end

  column :consent_waiver do
    if mentor_profile.present?
      consent_waiver.present? ? "signed" : "not signed"
    else
      "-"
    end
  end

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
    link_to(
      "view",
      send("#{current_scope}_participant_path", account),
      data: { turbolinks: false }
    )
  end

  filter :division,
    :enum,
    header: "Division (students only)",
    select: [["Senior", "senior"], ["Junior", "junior"]],
    filter_group: "common",
    html: {
      class: "and-or-field",
    } do |value|
    by_division(value)
  end

  filter :team_matching,
    :enum,
    header: "Team matchng (students & mentors only)",
    select: [
      ['Matched with a team', 'matched'],
      ['Unmatched', 'unmatched'],
    ],
    filter_group: "common",
    if: ->(g) {
      (%w{judge regional_ambassador} & (g.scope_names || [])).empty?
    } { |value| send(value) }

  filter :parental_consent,
    :enum,
    header: "Parental consent (students only)",
    select: [
      ['Has parental consent', 'parental_consented'],
      ['No parental consent', 'not_parental_consented'],
    ],
    filter_group: "common",
    if: ->(g) {
      (%w{judge regional_ambassador mentor} & (g.scope_names || [])).empty?
    } do |value, scope, grid|
      scope.send(value, grid.season)
    end

  filter :consent_waiver,
    :enum,
    header: "Consent waiver (mentors only)",
    select: [
      ['Signed consent waiver', 'consent_signed'],
      ['Has not signed', 'consent_not_signed'],
    ],
    filter_group: "common",
    if: ->(g) {
      (%w{judge regional_ambassador student} & (g.scope_names || [])).empty?
    } { |value| send(value) }

  filter :background_check,
    :enum,
    header: "Background check (mentors only)",
    select: ->(g) {
      if g.admin
        [
          ['Has not submitted (US only)', 'bg_check_unsubmitted'],
          ['Has submitted, is waiting (US only)', 'bg_check_submitted'],
          ['Clear (US only) or not required (International)', 'bg_check_clear'],
          ['Consider (US only)', 'bg_check_consider'],
          ['Suspended (US only)', 'bg_check_suspended'],
        ]
      else
        [
          ['Has not submitted', 'bg_check_unsubmitted'],
          ['Has submitted, is waiting', 'bg_check_submitted'],
          ['Clear', 'bg_check_clear'],
          ['Consider', 'bg_check_consider'],
          ['Suspended', 'bg_check_suspended'],
        ]
      end
    },
    filter_group: "common",
    if: ->(g) {
      g.country.empty? or
        g.country[0] == "US" and
          (%w{judge regional_ambassador student} & (g.scope_names || [])).empty?
    } { |value| send(value) }

  filter :name_email, header: "Name or Email", filter_group: "more-specific" do |value|
    names = value.strip.downcase.split(' ').map { |n| I18n.transliterate(n) }
    fuzzy_search({
      first_name: names.first,
      last_name: names.last || names.first,
      email: names.first,
    }, false)
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

  filter :scope_names,
    :enum,
    header: "Profile type",
    select: [
      ['Students', 'student'],
      ['Mentors', 'mentor'],
      ['Judges', 'judge'],
      ['Regional Ambassadors', 'regional_ambassador'],
    ],
    filter_group: "more-specific",
    html: {
      class: "and-or-field",
    },
    multiple: true do |values|
      clauses = values.flatten.map do |v|
        sql_str = "#{v}_profiles.id IS NOT NULL"

        if v == "regional_ambassador"
          sql_str += " AND regional_ambassador_profiles.status = #{
            RegionalAmbassadorProfile.statuses[:approved]
          }"
        end

        sql_str
      end

      where(clauses.join(' OR '))
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
    if: ->(g) {
      (g.admin or g.allow_state_search) and
        g.country.one? and
          CS.get(g.country[0]).any?
    } do |values, scope, grid|
      clauses = values.flatten.map do |v|
        v = v === "DIF" ? "CDMX" : v
        "lower(accounts.state_province) like '#{v.downcase}%'"
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
        "accounts.city = '#{v}'"
      end

      state = grid.state_province[0]
      state = state === "DIF" ? "CDMX" : state

      scope.where("lower(accounts.state_province) like '#{state.downcase}%'")
        .where(clauses.join(' OR '))
    end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
