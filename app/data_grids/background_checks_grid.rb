class BackgroundChecksGrid
  include Datagrid

  self.batch_size = 10

  scope do
    BackgroundCheck.order(created_at: :desc)
  end

  column :account, mandatory: true, html: true do |background_check|
    if background_check.account.present?
      link_to(
        background_check.account.full_name,
        admin_participant_path(background_check.account)
      )
    else
      "-"
    end
  end

  column :profile_type, header: "Profile Type" do |background_check|
    background_check.account.scope_name.titleize
  end

  column :country, header: "Country" do |background_check|
    FriendlyCountry.new(background_check.account).country_name
  end

  column :background_check, header: "Background Check", mandatory: true do |background_check|
    background_check.status.titleize
  end

  column :invitation_status, header: "Invitation Status", mandatory: true do |background_check|
    if background_check.invitation_status.present?
      background_check.invitation_status.titleize
    else
      "-"
    end
  end

  filter :status,
    :enum,
    header: "Background Check Status",
    select: BackgroundCheck.statuses.transform_keys(&:humanize)

  filter :invitation_status,
    :enum,
    header: "Invitation Status",
    select: BackgroundCheck.invitation_statuses.transform_keys(&:capitalize)

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
