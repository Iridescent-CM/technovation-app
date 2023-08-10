class ParentalConsentsGrid
  include Datagrid

  attr_accessor :admin

  scope do
    ParentalConsent.where.not(uploaded_at: nil)
  end

  column :student, mandatory: true, html: true do |parental_consent|
    link_to(
      parental_consent.student_profile&.account&.full_name,
      admin_participant_path(parental_consent.student_profile&.account)
    )
  end

  column :email, header: "Student Email Address", mandatory: true do |parental_consent|
    parental_consent.student_profile&.account&.email
  end

  column :uploaded_at, header: "Uploaded On", mandatory: true do |parental_consent|
    parental_consent.uploaded_at.strftime("%B %e, %Y %l:%M %p")
  end

  column :upload_approval_status, header: "Status", mandatory: true do |parental_consent|
    parental_consent.upload_approval_status.capitalize
  end

  column :actions, mandatory: true, html: true do |parental_consent|
    view_button = link_to(
      "View",
      parental_consent.uploaded_consent_form.url,
      class: "button small",
      target: :_blank,
      data: {turbolinks: false}
    )

    approve_button = link_to(
      "Approve",
      admin_paper_parental_consent_approve_path(parental_consent),
      class: "button small",
      data: {
        method: :patch,
        confirm: "You are about to approve this parental consent"
      }
    )

    reject_button = link_to(
      "Reject",
      admin_paper_parental_consent_reject_path(parental_consent),
      class: "button danger small",
      data: {
        method: :patch,
        confirm: "You are about to reject this parental consent"
      }
    )

    if parental_consent.upload_approval_status_pending?
      view_button + " " + approve_button + " " + reject_button
    else
      view_button
    end
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
    select: ParentalConsent::PAPER_CONSENT_UPLOAD_STATUSES.transform_keys(&:capitalize)

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
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
