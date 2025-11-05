class ChapterAmbassadorsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  self.batch_size = 10

  scope do
    Account
      .includes(:chapter_ambassador_profile, :chapterable_assignments, :chapters)
      .where.not(chapter_ambassador_profiles: {id: nil})
      .order(id: :desc)
  end

  column :name, header: "Chapters (Program Name)", mandatory: true do |account|
    if account.current_chapter.present?
      format(account.chapter_program_name) do
        link_to(
          account.chapter_program_name || "-",
          admin_chapter_path(account.current_chapter)
        )
      end
    else
      "No chapter"
    end
  end

  column :organization_name, header: "Organization Name", mandatory: true do |account|
    if account.current_chapter.present?
      account.chapter_organization_name.presence || "-"
    else
      "No organization"
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

  column :onboarded do
    chapter_ambassador_profile.onboarded? ? "yes" : "no"
  end

  column :phone_number do
    chapter_ambassador_profile.phone_number.presence || "-"
  end

  column :organization_status do
    chapter_ambassador_profile.organization_status.presence || "-"
  end

  column :national_view do
    ApplicationController
      .helpers
      .humanize_boolean(chapter_ambassador_profile.national_view?)
  end

  column :mentor, header: "Mentor?" do
    mentor_profile.present? ? "yes" : "no"
  end

  column :city

  column :state_province, header: "State" do
    FriendlySubregion.call(self, prefix: false)
  end

  column :country do
    FriendlyCountry.new(self).country_name
  end

  column :availability do
    availability_slots = chapter_ambassador_profile.community_connection&.community_connection_availability_slots
    if availability_slots&.any?
      availability_slots.joins(:availability_slot).pluck(:time).join(", ")
    else
      "-"
    end
  end

  column :topics_to_share do
    chapter_ambassador_profile&.community_connection&.topic_sharing_response.presence || "-"
  end

  column :training_checkpoint do
    chapter_ambassador_profile.training_completed? ? "Yes" : "No"
  end

  column :remaining_chapter_ambassador_onboarding_tasks,
    preload: [
      chapter_ambassador_profile: [
        :chapter_volunteer_agreement
      ]
    ] do
    chapter_ambassador_profile.incomplete_onboarding_tasks.to_sentence
  end

  column :remaining_chapter_onboarding_tasks do
    if current_chapter.present?
      current_chapter.incomplete_onboarding_tasks.to_sentence
    else
      "(Not assigned to a chapter)"
    end
  end

  column :completed_chapter_ambassador_onboarding_tasks,
    preload: [
      :background_check,
      chapter_ambassador_profile: [
        :chapter_volunteer_agreement
      ]
    ] do
    chapter_ambassador_profile.complete_onboarding_tasks.to_sentence
  end

  column :completed_chapter_onboarding_tasks do
    if current_chapter.present?
      current_chapter.complete_onboarding_tasks.to_sentence
    else
      "(Not assigned to a chapter)"
    end
  end

  column :actions, mandatory: true, html: true do |account|
    link_to(
      "view",
      send(:"#{current_scope}_participant_path", account),
      data: {turbo: false}
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

  filter :availability,
    :enum,
    header: "Availability",
    select: proc { AvailabilitySlot.all.map { |slot| [slot.time, slot.id] } },
    filter_group: "more-specific",
    html: {
      class: "and-or-field"
    },
    multiple: true do |values, scope|
      scope
        .includes(chapter_ambassador_profile: {community_connection: :community_connection_availability_slots})
        .references(:community_connection_availability_slots)
        .where(community_connection_availability_slots: {availability_slot_id: values})
    end

  filter :assigned_to_chapter,
    :enum,
    header: "Assigned to Chapter (only applies to current season)",
    select: [
      ["Yes", "yes"],
      ["No", "no"]
    ],
    filter_group: "common" do |value, scope, grid|
      if value == "yes"
        scope
          .joins(:chapterable_assignments)
          .where(
            chapterable_assignments: {
              season: Season.current.year
            }
          )
      else
        scope
          .where.not(
            id: ChapterableAccountAssignment.where(
              season: Season.current.year,
              profile_type: "ChapterAmbassadorProfile"
            ).select(:account_id)
          )
      end
    end

  filter :chapter_status,
    :enum,
    header: "Chapter Status (only applies to current season)",
    select: [
      ["Active"],
      ["Inactive"]
    ],
    filter_group: "common" do |value, scope, grid|
      if value == "Active"
        scope
          .where("'#{Season.current.year}' = ANY (chapters.seasons)")
      else
        scope
          .where.not("'#{Season.current.year}' = ANY (chapters.seasons)")
      end
    end

  filter :national_view,
    :enum,
    select: [
      ["Yes", true],
      ["No", false]
    ],
    filter_group: "common" do |value, scope, grid|
      scope
        .where(chapter_ambassador_profiles: {national_view: value})
    end

  filter :onboarded,
    :enum,
    header: "Onboarded (includes Chapter onboarding)",
    select: [
      ["Yes, fully onboarded", true],
      ["No, still onboarding", false]
    ],
    filter_group: "common" do |value, scope, grid|
      if value == "true"
        scope
          .where(chapter_ambassador_profiles: {onboarded: true})
          .where(chapters: {onboarded: true})
      else
        scope
          .where(chapter_ambassador_profiles: {onboarded: false})
          .or(scope.where(chapters: {onboarded: false}))
      end
    end

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
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
        .left_outer_joins(:chapter_ambassador_profile)
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

  filter :program_name do |value, scope|
    scope
      .where("chapters.name ilike ?", "%#{value}%")
  end

  filter :organization_name do |value, scope|
    scope
      .where("chapters.organization_name ilike ?", "%#{value}%")
  end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
