class ChaptersGrid
  include Datagrid

  self.batch_size = 10

  scope do
    Chapter.order(id: :desc)
  end

  filter :program_name do |value|
    sanitized = sanitize_sql_like(value)
    processed_value = I18n.transliterate(sanitized.strip.downcase).gsub(/['\s]+/, "%")

    where("lower(unaccent(name)) ILIKE ?", "%#{processed_value}%")
  end

  filter :organization_name, header: "Organization" do |value|
    value = sanitize_sql_like(value)
    processed_value = I18n.transliterate(value.strip.downcase).gsub(/['\s]+/, "%")

    where("lower(unaccent(organization_name)) ILIKE ?", "%#{processed_value}%")
  end

  filter(:onboarded,
    :enum,
    select: [
      ["Yes, fully onboarded", true],
      ["No, still onboarding", false]
    ]) do |value|
      where(onboarded: value)
    end

  filter :affiliation_agreement_status,
    :enum,
    select: ["Signed", "Not signed", "Not sent"] do |value|
      case value
      when "Signed"
        signed_affiliation_agreements
      when "Not signed"
        not_signed_affiliation_agreements
      when "Not sent"
        not_sent_affiliation_agreements
      end
    end

  filter(:visible_on_map, :xboolean)

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
    } do |values|
    clauses = values.flatten.map { |v| "chapters.country = '#{v}'" }
    where(clauses.join(" OR "))
  end

  filter :organization_type,
    :enum,
    header: "Organization type",
    select: proc { OrganizationType.all.map { |type| [type.name, type.id] } },
    filter_group: "more-specific",
    html: {
      class: "and-or-field"
    },
    multiple: true do |values, scope|
    scope.includes(chapter_program_information: {organization_types: :chapter_program_information_organization_types})
      .references(:chapter_program_information_organization_types)
      .where(chapter_program_information_organization_types: {organization_type_id: values})
  end

  filter :season,
    :enum,
    select: (2025..Season.current.year).to_a.reverse,
    filter_group: "more-specific",
    html: {
      class: "and-or-field"
    },
    multiple: false do |value|
    by_season(value)
  end

  column :name, header: "Chapters (Program Name)", mandatory: true, html: true do |chapter|
    link_to(
      chapter.name.presence || "-",
      admin_chapter_path(chapter)
    )
  end

  column :name, header: "Chapter (Program Name)", html: false do |chapter|
    chapter.name.presence || "-"
  end

  column :organization_name, header: "Organization", mandatory: true

  column :organization_type, header: "Organization type" do
    organization_types = chapter_program_information&.organization_types
    if organization_types&.any?
      organization_types.pluck(:name).join(", ")
    else
      "-"
    end
  end

  column :summary

  column :organization_headquarters_location

  column :onboarded do
    onboarded? ? "yes" : "no"
  end

  column :remaining_onboarding_tasks,
    preload: [
      :chapter_links,
      :chapter_program_information,
      :legal_contact,
      :primary_contact,
      chapter_program_information: [
        :low_income_estimate,
        :meeting_facilitators,
        :meeting_times,
        :organization_types,
        :participant_count_estimate,
        :program_length
      ],
      legal_contact: [
        :chapter_affiliation_agreement
      ]
    ] do
    incomplete_onboarding_tasks.to_sentence
  end

  column :completed_onboarding_tasks,
    preload: [
      :chapter_links,
      :chapter_program_information,
      :legal_contact,
      :primary_contact,
      chapter_program_information: [
        :low_income_estimate,
        :meeting_facilitators,
        :meeting_times,
        :organization_types,
        :participant_count_estimate,
        :program_length
      ],
      legal_contact: [
        :chapter_affiliation_agreement
      ]
    ] do
    complete_onboarding_tasks.to_sentence
  end

  column :affiliation_agreement_status, preload: [:legal_contact, legal_contact: :chapter_affiliation_agreement] do
    if affiliation_agreement.present?
      if affiliation_agreement_complete?
        if affiliation_agreement.signed?
          "Signed"
        elsif affiliation_agreement.off_platform?
          "Off-platform"
        else
          "Not signed"
        end
      else
        "Not sent"
      end
    end
  end

  column :season_affiliation_agreement_signed, preload: [:legal_contact, legal_contact: :chapter_affiliation_agreement] do
    if affiliation_agreement.present?
      affiliation_agreement.season_signed.presence || "-"
    end
  end

  column :season_affiliation_agreement_expires, preload: [:legal_contact, legal_contact: :chapter_affiliation_agreement] do
    if affiliation_agreement.present?
      affiliation_agreement.season_expires.presence || "-"
    end
  end

  column :affiliation_agreement_valid_for, preload: [:legal_contact, legal_contact: :chapter_affiliation_agreement] do
    legal_contact&.seasons_chapter_affiliation_agreement_is_valid_for&.join(", ")
  end

  column :legal_contact_name, preload: [:legal_contact] do
    legal_contact&.full_name.presence || "-"
  end

  column :legal_contact_email_address, preload: [:legal_contact] do
    legal_contact&.email_address.presence || "-"
  end

  column :primary_contact_name, preload: [:primary_contact] do
    primary_contact&.full_name.presence || "-"
  end

  column :primary_contact_email_address, preload: [:primary_contact] do
    primary_contact&.email.presence || "-"
  end

  column :updated_at, header: "Last updated at" do
    updated_at&.strftime("%Y-%m-%d %H:%M %Z").presence || "-"
  end

  column :city

  column :state_province, header: "State" do
    FriendlySubregion.call(self, prefix: false)
  end

  column :country do
    FriendlyCountry.new(self).country_name
  end

  column :visible_on_map, header: "Visible on map"

  column :child_safeguarding_policy_and_process, preload: :chapter_program_information do
    chapter_program_information&.child_safeguarding_policy_and_process.presence || "-"
  end

  column :team_structure, preload: :chapter_program_information do
    chapter_program_information&.team_structure.presence || "-"
  end

  column :external_partnerships, preload: :chapter_program_information do
    chapter_program_information&.external_partnerships.presence || "-"
  end

  column :start_date, header: "Program start date", preload: :chapter_program_information do
    chapter_program_information&.start_date&.strftime("%m-%d-%Y").presence || "-"
  end

  column :launch_date, preload: :chapter_program_information do
    chapter_program_information&.launch_date&.strftime("%m-%d-%Y").presence || "-"
  end

  column :program_model, preload: :chapter_program_information do
    chapter_program_information&.program_model.presence || "-"
  end

  column :meeting_times, preload: :chapter_program_information do
    meeting_times = chapter_program_information&.meeting_times
    if meeting_times&.any?
      meeting_times.pluck(:time).join(", ")
    else
      "-"
    end
  end

  column :program_length, preload: :chapter_program_information do
    chapter_program_information&.program_length&.length.presence || "-"
  end

  column :meeting_facilitators, preload: :chapter_program_information do
    meeting_facilitators = chapter_program_information&.meeting_facilitators
    if meeting_facilitators&.any?
      meeting_facilitators.pluck(:name).join(", ")
    else
      "-"
    end
  end

  column :participant_count_estimate, header: "Estimated participation", preload: :chapter_program_information do
    chapter_program_information&.participant_count_estimate&.range.presence || "-"
  end

  column :low_income_estimate, header: "Percent underresourced", preload: :chapter_program_information do
    chapter_program_information&.low_income_estimate&.percentage.presence || "-"
  end

  column :number_of_low_income_or_underserved_calculation, preload: :chapter_program_information do
    chapter_program_information&.number_of_low_income_or_underserved_calculation.presence || "-"
  end

  column :seasons do
    seasons.to_sentence
  end

  column :actions, mandatory: true, html: true do |chapter|
    render "admin/chapters/actions", chapter: chapter
  end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
