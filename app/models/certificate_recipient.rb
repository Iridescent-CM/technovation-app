class CertificateRecipient
  attr_reader :profile, :account, :team,
   :id, :mobileAppName, :fullName, :teamName, :region

  def initialize(profile)
    @profile = profile
    @account = profile.account
    @team = profile.teams.last # TODO this is placeholder logic ONLY

    @id = account.id
    @mobileAppName = team.submission.app_name
    @fullName = account.name
    @teamName = team.name
    @region = FriendlyCountry.(account, prefix: false)
  end

  def [](fieldName)
    public_send(fieldName)
  end
end