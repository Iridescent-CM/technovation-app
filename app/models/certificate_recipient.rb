require "./app/technovation/friendly_country"

class CertificateRecipient
  attr_reader :account, :team,
   :id, :mobileAppName, :fullName, :teamName, :region

  def initialize(account, team)
    @account = account
    @team = team

    @id = account.id
    @mobileAppName = team.submission.app_name
    @fullName = account.name
    @teamName = team.name
    @region = FriendlyCountry.(account, prefix: false)
  end

  def [](fieldName)
    public_send(fieldName)
  end

  def needed_certificate_types
    types = []
    types.push("participation") if needs_participation_certificate?
    types.push("completion")    if needs_completion_certificate?
    types.push("semifinalist")  if needs_semifinalist_certificate?
    types
  end

  def certificate_types
    types = []
    types.push("participation") if gets_participation_certificate?
    types.push("completion")    if gets_completion_certificate?
    types.push("semifinalist")  if gets_semifinalist_certificate?
    types
  end

  def certificates
    certificate_types.map { |certificate_type|
      account.certificates
             .current
             .public_send(certificate_type)
             .last
    }.compact
  end

  private
  def needs_completion_certificate?
      gets_completion_certificate? &&
        !account.certificates.completion.current.any?
  end

  def gets_completion_certificate?
    team.submission.complete? &&
      team.submission.quarterfinalist?
  end

  def needs_participation_certificate?
    gets_participation_certificate? &&
      !account.certificates.participation.current.any?
  end

  def gets_participation_certificate?
    team.submission.qualifies_for_participation?
  end

  def needs_semifinalist_certificate?
    gets_semifinalist_certificate? &&
      !account.certificates.semifinalist.current.any?
  end

  def gets_semifinalist_certificate?
    team.submission.semifinalist?
  end
end