require "./app/constants/certificate_types"
require "./app/models/friendly_country"
require "./app/null_objects/null_team"

class CertificateRecipient
  attr_reader :certificate_type, :account, :team,
    :id, :mobile_app_name, :full_name,
    :team_name, :team_id, :season

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
  end

  def region
    FriendlyCountry.(account, prefix: false)
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

  def certificates
    @account.certificates.by_season(@season).public_send(@certificate_type).for_team(@team)
  end

  def certificate_issued?
    certificates.any?
  end

  def ==(o)
    o.class == self.class && o.state == self.state
  end

  def state
    return [
      @certificate_type.to_s,
      @account.id,
      @team.nil? ? nil : @team.id,
      @season
    ]
  end

  def self.from_state(state)
    certificate_type, account_id, team_id, season = state

    certificate_type = certificate_type.to_sym
    account = Account.find(account_id)
    if team_id
      team = Team.find(team_id)
    else
      team = nil
    end

    new(certificate_type, account, team: team, season: season)
  end

end