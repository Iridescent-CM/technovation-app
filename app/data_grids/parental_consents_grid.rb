class ParentalConsentsGrid
  include Datagrid

  attr_accessor :admin

  scope do
    ParentalConsent.where.not(uploaded_at: nil)
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

  column :uploaded_at, header: "Uploaded On", mandatory: true do |parental_consent|
    parental_consent.uploaded_at.strftime("%B %e, %Y %l:%M %p")
  end

  column :upload_approval_status, header: "Status", mandatory: true do |parental_consent|
    parental_consent.upload_approval_status.capitalize
  end

  column :actions, mandatory: true, html: true do |parental_consent|
    render "admin/paper_parental_consents/actions", parental_consent: parental_consent
  end

  column :upload_approved_at, header: "Approved On" do |parental_consent|
    parental_consent.upload_approved_at&.strftime("%B %e, %Y %l:%M %p")
  end

  column :upload_rejected_at, header: "Rejected On" do |parental_consent|
    parental_consent.upload_rejected_at&.strftime("%B %e, %Y %l:%M %p")
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

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
