class JudgesGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search, :current_account, :current_judging_round

  self.batch_size = 10

  def self.current_judging_round
    round = SeasonToggles.current_judging_round(full_name: true)
    return :quarterfinals if round.to_sym == :off
    round
  end

  scope do
    Account.includes(judge_profile: :events)
      .references(:judge_profiles, :regional_pitch_events)
      .where("judge_profiles.id IS NOT NULL")
  end

  column :mentor, header: "Mentor?", mandatory: true do
    mentor_profile.present? ? "yes" : "no"
  end

  column :first_name, mandatory: true
  column :last_name, mandatory: true
  column :email, mandatory: true

  column :quarterfinals_scores_count,
    header: "Complete Quarterfinals Scores",
    order: "judge_profiles.quarterfinals_scores_count" do |asset, grid|
    asset.judge_profile.quarterfinals_scores_count
  end

  column :semifinals_scores_count,
  header: "Complete Semifinals Scores",
    order: "judge_profiles.semifinals_scores_count" do |asset, grid|
    asset.judge_profile.semifinals_scores_count
  end

  column :judge_rank do |account, grid|
    rank = DetermineCertificates.new(account).eligible_types.select { |type|
      type.include?("judge")
    }.first

    if rank
      rank.humanize.titleize
    else
      ""
    end
  end

  column :industry do
    if judge_profile.present?
      judge_profile.industry_text
    else
      "-"
    end
  end

  column :skills do
    if judge_profile.present?
      judge_profile.skills
    else
      "-"
    end
  end

  column :degree do
    if judge_profile.present?
      judge_profile.degree
    else
      "-"
    end
  end

  column :get_school_company_name, order: "judge_profiles.company_name"

  column :onboarded do
    judge_profile.onboarded? ? "yes" : "no"
  end

  column :age, order: "accounts.date_of_birth desc"

  column :city

  column :state_province, header: "State" do
    FriendlySubregion.(self, prefix: false)
  end

  column :country do
    FriendlyCountry.new(self).country_name
  end

  column :referred_by do
    referred = referred_by

    if referred == "Other"
      referred += " - #{referred_by_other}"
    end

    referred
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

  filter :onboarded,
    :enum,
    select: [
      ['Yes, fully onboarded', 'onboarded'],
      ['No, still onboarding', 'onboarding'],
    ],
    filter_group: "common" do |value, scope, grid|
      scope.where(
        "judge_profiles.onboarded = ?",
         value == 'onboarded' ? true : false
      )
    end

  filter :has_mentor_profile,
    :enum,
    select: [
      ['Yes, is also a mentor', 'yes'],
      ['No', 'no'],
    ],
    filter_group: "common" do |value, scope, grid|
      is_is_not = value === 'yes' ? "IS NOT" : "IS"

      scope.left_outer_joins(:mentor_profile).where(
        "mentor_profiles.id #{is_is_not} NULL"
      )
    end

  filter :by_event,
    :enum,
    select: ->(grid) {
      RegionalPitchEvent.visible_to(grid.current_account)
        .current
        .order(:name)
        .map { |e| [e.name, e.id] }
    },
    if: ->(g) { g.admin or RegionalPitchEvent.visible_to(g.current_account).any? } do |value|
      where("regional_pitch_events.id = ?", value)
  end

  filter :virtual_or_live,
    :enum,
    select: [
      ['Virtual judges', 'virtual'],
      ['Live event judges', 'live'],
    ],
    filter_group: "common" do |value, scope, grid|
      is_is_not = value === "virtual" ? "IS" : "IS NOT"

      scope.where("regional_pitch_events.id #{is_is_not} NULL")
    end

  filter :name_email,
    header: "Name or Email",
    filter_group: "more-specific" do |value|
      names = value.strip.downcase.split(' ').map { |n|
        I18n.transliterate(n).gsub("'", "''")
      }
    fuzzy_search({
      first_name: names.first,
      last_name: names.last || names.first,
      email: names.first,
    }, false) # false enables OR search
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
      scope.where(country: grid.country)
        .where(
          StateClauses.for(
            values: values,
            countries: grid.country,
            table_name: 'accounts',
            operator: 'OR'
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

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end