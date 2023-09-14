class ParentalConsentsGrid
  include Datagrid

  attr_accessor :admin, :allow_state_search

  scope do
    ParentalConsent.where.not(uploaded_at: nil).includes(student_profile: :account).references(:accounts)
  end

  column :student, mandatory: true, html: true do |parental_consent|
    link_to(
      parental_consent.student_profile_full_name,
      admin_participant_path(parental_consent.student_profile&.account)
    )
  end

  column :student, html: false do |parental_consent|
    parental_consent.student_profile_full_name
  end

  column :email, header: "Student Email Address", mandatory: true do |parental_consent|
    parental_consent.student_profile_email
  end

  column :city do |parental_consent|
    parental_consent.student_profile.city
  end

  column :state_province, header: "State/Province" do |parental_consent|
    FriendlySubregion.call(parental_consent.student_profile.account, prefix: false)
  end

  column :country do |parental_consent|
    Carmen::Country.coded(parental_consent.student_profile.country) || Carmen::Country.named(parental_consent.student_profile.country)
  end

  column :uploaded_at, header: "Uploaded On", mandatory: true do |parental_consent|
    parental_consent.uploaded_at.strftime("%B %e, %Y %l:%M %p")
  end

  column :upload_approved_at, header: "Approved On" do |parental_consent|
    parental_consent.upload_approved_at&.strftime("%B %e, %Y %l:%M %p")
  end

  column :upload_rejected_at, header: "Rejected On" do |parental_consent|
    parental_consent.upload_rejected_at&.strftime("%B %e, %Y %l:%M %p")
  end

  column :upload_approval_status, header: "Status", mandatory: true do |parental_consent|
    parental_consent.upload_approval_status.capitalize
  end

  column :actions, mandatory: true, html: true do |parental_consent|
    render "admin/paper_parental_consents/actions", parental_consent: parental_consent
  end

  filter :upload_approval_status,
    :enum,
    header: "Status",
    select: ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES.transform_keys(&:capitalize)

  filter :season,
    :enum,
    select: (ConsentForms::FIRST_SEASON_FOR_UPLOADABLE_CONSENT_FORMS..Season.current.year).to_a.reverse,
    filter_group: "selections",
    html: {
      class: "and-or-field"
    },
    multiple: true do |value, scope, grid|
      scope.by_season(value)
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
