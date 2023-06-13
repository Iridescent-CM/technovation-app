class AccountsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 1_000

  scope do
    Account.not_admin
  end

  column :id, header: "Participant ID", if: ->(g) { g.admin }

  column :profile_type do
    scope_name
  end

  column :first_name, mandatory: true
  column :last_name, mandatory: true
  column :email, mandatory: true

  column :mentor_type do
    if mentor_profile.present?
      mentor_profile.mentor_type
    else
      "-"
    end
  end

  column :mentor_expertise do
    if mentor_profile.present?
      mentor_profile.expertise_names.join(",")
    else
      "-"
    end
  end

  column :judge_industry do
    if judge_profile.present?
      judge_profile.industry_text
    else
      "-"
    end
  end

  column :judge_skills do
    if judge_profile.present?
      judge_profile.skills
    else
      "-"
    end
  end

  column :judge_degree do
    if judge_profile.present?
      judge_profile.degree
    else
      "-"
    end
  end

  column :suspended, if: ->(g) { g.admin } do
    if judge_profile.present? && judge_profile.suspended?
      "Yes"
    else
      "No"
    end
  end

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

  column :school_name, order: ->(scope) {
    scope.includes(:student_profile)
      .references(:student_profiles)
      .order("student_profiles.school_name")
  } do
    if student_profile.present?
      student_profile.school_name
    else
      "-"
    end
  end

  column :company_name, order: ->(scope) {
    scope.includes(
      :chapter_ambassador_profile,
      :mentor_profile,
      :judge_profile,
    ).references(
      :chapter_ambassador_profiles,
      :mentor_profiles,
      :judge_profiles,
    ).order(
      "chapter_ambassador_profiles.organization_company_name, " +
      "mentor_profiles.school_company_name, " +
      "judge_profiles.company_name"
    )
  } do
    if student_profile.present?
      "-"
    elsif chapter_ambassador_profile.present?
      chapter_ambassador_profile.organization_company_name
    elsif mentor_profile.present?
      mentor_profile.school_company_name
    elsif judge_profile.present?
      judge_profile.company_name
    else
      "-"
    end
  end

  column :team_division do
    if student_profile.present?
      Division.for(self).name.humanize
    else
      "-"
    end
  end

  column :team_names, header: "Team name(s)" do
    if student_profile.present? or mentor_profile.present?
      teams.current.map(&:name).to_sentence
    else
      "-"
    end
  end

  column :filled_out_bio, header: "Filled out bio?" do
    if mentor_profile.present?
      mentor_profile.bio.blank? ? "No" : "Yes"
    else
      "-"
    end
  end

  column :background_check, if: ->(g) {
    g.admin or Array(g.country)[0] == "US"
  } do
    if country_code == "US" && mentor_profile.present?
      background_check.present? ?
        background_check.status :
        "Not submitted"
    elsif mentor_profile.present?
      "-"
    else
      "-"
    end
  end

  column :parental_consent do |account, grid|
    if account.student_profile.present? && account.parental_consent(grid.season).present?
      account.parental_consent(grid.season).status
    else
      "-"
    end
  end

  column :media_consent do |account, grid|
    if account.student_profile.present? && account.student_profile.media_consent.present?
      account.student_profile.media_consent.consent_provided ? "Yes" : "No"
    else
      "-"
    end
  end

  column :consent_waiver do
    if mentor_profile.present? || judge_profile.present?
      consent_waiver.present? ? "Signed" : "Not signed"
    else
      "-"
    end
  end

  column :mentor_training do
    if mentor_profile.present? && mentor_profile.training_required?
      mentor_profile.training_complete? ? "Yes" : "No"
    elsif mentor_profile.present? && !mentor_profile.training_required?
      "N/A"
    else
      "-"
    end
  end

  column :returning, header: "Returning?" do |account|
    account.returning? ? "Yes" : "No"
  end

  column :onboarded_judges do
    if judge_profile.present?
      judge_profile.onboarded? ? "Yes" : "No"
    else
      "-"
    end
  end

  column :virtual_or_live do
    if judge_profile.present?
      judge_profile.live_event? ? "Live" : "Virtual"
    else
      "-"
    end
  end

  column :age, order: "accounts.date_of_birth desc"
  column :city

  column :state_province, header: "State" do |account, _grid|
    FriendlySubregion.(account, prefix: false)
  end

  column :country do |account, _grid|
    FriendlyCountry.new(account).country_name
  end

  column :geolocation, header: "Geolocation", if: ->(g) {
    g.admin
  } do
    "#{latitude},#{longitude}"
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

  column :actions, mandatory: true, html: true do |account, grid|
    html = link_to(
      "view",
      send("#{current_scope}_participant_path", account),
      data: { turbolinks: false }
    )

    if grid.admin
      html += " | "

      html += link_to(
        'login',
        admin_participant_session_path(account),
      )
    end

    html
  end

  filter :division,
    :enum,
    header: "Division (students only)",
    select: [["Senior", "senior"], ["Junior", "junior"], ["Beginner", "beginner"]],
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
      ['Mentors who have not answered invites from teams', 'mentors_pending_invites'],
      ['Mentors with open join requests to teams', 'mentors_pending_requests'],
    ],
    filter_group: "common",
    if: ->(g) {
      (%w{judge chapter_ambassador} & (g.scope_names || [])).empty?
    } do |value, scope, grid|
      scope.send(value)
    end

  filter :onboarded_students,
    :enum,
    select: [
      ['Yes, fully onboarded', 'onboarded'],
      ['No, still onboarding', 'onboarding'],
    ],
    filter_group: "common",
    if: ->(g) {
      (%w{judge mentor chapter_ambassador} & (g.scope_names || [])).empty?
    } do |value, scope, grid|
      scope.includes(:student_profile)
        .references(:student_profiles)
        .where(
        "student_profiles.id IS NOT NULL AND " +
        "student_profiles.onboarded = ?",
         value == 'onboarded' ? true : false
      )
    end

  filter :onboarded_mentors,
    :enum,
    select: [
      ['Yes, fully onboarded', 'onboarded'],
      ['No, still onboarding', 'onboarding'],
    ],
    filter_group: "common",
    if: ->(g) {
      (%w{judge student chapter_ambassador} & (g.scope_names || [])).empty?
    } do |value, scope, grid|
      scope.send("#{value}_mentors")
    end

  filter :onboarded_judges,
    :enum,
    select: [
      ['Yes, fully onboarded', 'onboarded'],
      ['No, still onboarding', 'onboarding'],
    ],
    filter_group: "common",
    if: ->(g) {
      (%w{student mentor chapter_ambassador} & (g.scope_names || [])).empty?
    } do |value, scope, grid|
      scope.includes(:judge_profile)
        .references(:judge_profiles)
        .where("judge_profiles.id IS NOT NULL")
        .where(
          "judge_profiles.onboarded = ?",
           value == 'onboarded' ? true : false
        )
    end

  filter :suspended_judges,
    :enum,
    select: [
      ['Yes, suspended', 'suspended'],
      ['No, not suspended', 'active'],
    ],
    filter_group: "common",
    if: ->(g) {
      g.admin &&
        (%w{student mentor chapter_ambassador} & (g.scope_names || [])).empty?
    } do |value, scope, grid|
      scope.includes(:judge_profile)
        .references(:judge_profiles)
        .where("judge_profiles.id IS NOT NULL")
        .where("judge_profiles.suspended = ?", value == 'suspended')
    end

  filter :virtual_or_live,
    :enum,
    select: [
      ['Virtual judges', 'virtual'],
      ['Live event judges', 'live'],
    ],
    filter_group: "common",
    if: ->(g) {
      (%w{student mentor chapter_ambassador} & (g.scope_names || [])).empty?
    } do |value, scope, grid|
      is_is_not = value === "virtual" ? "IS" : "IS NOT"

      scope.includes(judge_profile: :events)
        .references(:judge_profiles, :regional_pitch_events)
        .where("judge_profiles.id IS NOT NULL")
        .where("regional_pitch_events.id #{is_is_not} NULL")
    end

  # filter :mentor_type,
  #   :enum,
  #   select: MENTOR_TYPE_OPTIONS,
  #   filter_group: "common",
  #   if: ->(g) {
  #     scopes = g.scope_names || []
  #     %w{student judge chapter_ambassador}.all? { |scope| scopes.exclude?(scope) }
  #   } do |value, scope, grid|
  #     scope.includes(:mentor_profile)
  #       .references(:mentor_profiles)
  #       .where(mentor_profiles: { mentor_type: value })
  #   end

  filter :school_company_name,
    header: "School or company name (judges and mentors)",
    filter_group: "common" do |value, scope|
      scope
        .includes(:mentor_profile)
          .references(:mentor_profiles)
        .includes(:judge_profile)
          .references(:judge_profiles)
        .where(
          "mentor_profiles.school_company_name ILIKE ? OR " +
          "judge_profiles.company_name ILIKE ?",
          "%#{value}%",
          "%#{value}%"
        )
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

  filter :first_name,
    header: "First name (exact spelling)",
    filter_group: "more-specific" do |value|
      basic_search({
        first_name: value
      })
    end

  filter :last_name,
    header: "Last name (exact spelling)",
    filter_group: "more-specific" do |value|
      basic_search({
        last_name: value
      })
    end

  filter :email,
    header: "Email (exact spelling)",
    filter_group: "more-specific" do |value|
      basic_search({
        email: value
      })
    end

  filter :parent_or_guardian_name,
    header: "Parent or guardian name (exact spelling)",
    filter_group: "more-specific" do |value, scope|
      scope.includes(:student_profile)
        .references(:student_profiles)
        .basic_search({
          student_profiles: {
            parent_guardian_name: value
          }
        })
    end

  filter :parent_or_guardian_email,
    header: "Parent or guardian email (exact spelling)",
    filter_group: "more-specific" do |value, scope|
      scope.includes(:student_profile)
        .references(:student_profiles)
        .basic_search({
          student_profiles: {
            parent_guardian_email: value
          }
        })
    end

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
    filter_group: "more-specific",
    html: {
      class: "and-or-field",
    },
    multiple: true do |value, scope, grid|
    scope.by_season(value, match: grid.season_and_or)
  end

  filter :season_and_or,
    :enum,
    header: "Season options:",
    select: [
      ["Match any season", "match_any"],
      ["Match all seasons", "match_all"],
    ],
    filter_group: "more-specific" do |_, scope|
    scope
  end

  filter :scope_names,
    :enum,
    header: "Profile type",
    select: [
      ['Students', 'student'],
      ['Mentors', 'mentor'],
      ['Judges', 'judge'],
      ['Chapter Ambassadors', 'chapter_ambassador'],
    ],
    filter_group: "more-specific",
    html: {
      class: "and-or-field",
    },
    multiple: true do |values|
      clauses = values.flatten.map do |v|
        sql_str = "#{v}_profiles.id IS NOT NULL"

        if v == "chapter_ambassador"
          sql_str += " AND chapter_ambassador_profiles.status = #{
            ChapterAmbassadorProfile.statuses[:approved]
          }"
        end

        sql_str
      end

      includes = values.flatten.map { |v| "#{v}_profile" }
      references = values.flatten.map { |v| "#{v}_profiles" }

      includes(*includes)
      .references(*references)
      .where(clauses.join(' OR '))
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
