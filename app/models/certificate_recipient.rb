class CertificateRecipient
  attr_reader :profile, :account, :id, :mobileAppName, :fullName, :teamName, :region

  def initialize(profile)
    @profile = profile
    @account = profile.account

    @id = account.id
    @mobileAppName = profile.team.submission.app_name
    @fullName = account.name
    @teamName = profile.team.name
    @region = FriendlyCountry.(account, prefix: false)
  end

  def [](fieldName)
    public_send(fieldName)
  end
end