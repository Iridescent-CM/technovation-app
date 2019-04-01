class CertificatesGrid
  include Datagrid

  self.batch_size = 10

  scope do
    Certificate
      .includes(:account, :team)
      .references(:accounts, :teams)
  end

  column :season

  column :type do
    cert_type.humanize.titleize
  end

  column :recipient_name do
    account.full_name
  end

  column :email do
    account.email
  end

  column :team do
    team.present? ? team.name : ""
  end

  column :view, html: true do |certificate|
    link_to(
      web_icon('file-pdf-o', size: 16, remote: true),
      admin_certificate_path(certificate),
      {
        class: "view-details",
        "v-tooltip" => "'View certificate'",
        data: { turbolinks: false }
      }
    )
  end

  filter :email,
    filter_group: "searches" do |value|
      where("LOWER(accounts.email) = LOWER(?)", value)
    end

  filter :team_name,
    filter_group: "searches" do |value|
      where("LOWER(teams.name) = LOWER(?)", value)
    end

  filter :type,
    :enum,
    header: "Certificate type",
    select: CERTIFICATE_TYPES.map { |t|
      [t.humanize.titleize, t]
    },
    filter_group: "selections" do |value|
      public_send(value)
    end

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
    filter_group: "selections",
    html: {
      class: "and-or-field",
    },
    multiple: true do |value, scope, grid|
      scope.by_season(value)
    end
end
