require "./app/constants/certificate_types"
require "./app/models/friendly_country"
require "./app/null_objects/null_team"

class CertificateRecipient
  attr_reader :certificate_type, :account, :team,
    :id, :mobile_app_name, :full_name,
    :team_name, :region, :team_id, :season

  def initialize(certificate_type, account, **options)
    @certificate_type = certificate_type
    @team = options.fetch(:team) { ::NullTeam.new }
    @season = options.fetch(:season) { Season.current.year }

    if team.present?
      @season = team.season
      @team_id = team.id
      @mobile_app_name = team.submission.app_name
      @team_name = team.name
    end

    @account = account
    @id = account.id
    @full_name = account.name
    @region = FriendlyCountry.(account, prefix: false)
  end

  def [](fieldName)
    public_send(fieldName)
  end

  define_method("Recipient Name") do
    account.name
  end

  define_method("app name") do
    mobile_app_name
  end

  def ==(o)
    o.class == self.class && o.state == self.state
  end

  def state
    return [
      @certificate_type,
      @account.id,
      @team.id,
      @season
    ]
  end
end