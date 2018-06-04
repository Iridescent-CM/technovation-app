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

  def certificate_types
    types = []
    types.push("completion") if needs_completion_certificate?
    types
  end

  private
  def needs_completion_certificate?
    !account.certificates.completion.current.any? &&
      team.submission.complete?
  end
end