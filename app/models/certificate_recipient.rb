require "./app/technovation/friendly_country"

class CertificateRecipient
  attr_reader :account, :team,
    :id, :mobile_app_name, :full_name,
    :team_name, :region, :team_id

  def initialize(account, team)
    @account = account
    @team = team

    @id = account.id
    @team_id = team.id
    @mobile_app_name = team.submission.app_name
    @full_name = account.name
    @team_name = team.name
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
    types.push("mentor_appreciation")  if needs_appreciation_certificate?
    types
  end

  def certificate_types
    types = []
    types.push("participation") if gets_participation_certificate?
    types.push("completion")    if gets_completion_certificate?
    types.push("semifinalist")  if gets_semifinalist_certificate?
    types.push("mentor_appreciation")  if gets_appreciation_certificate?
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
      !account.current_completion_certificates.any?
  end

  def gets_completion_certificate?
    team.submission.complete? &&
      team.submission.quarterfinalist?
  end

  def needs_participation_certificate?
    gets_participation_certificate? &&
      !account.current_participation_certificates.any?
  end

  def gets_participation_certificate?
    team.submission.qualifies_for_participation?
  end

  def needs_semifinalist_certificate?
    gets_semifinalist_certificate? &&
      !account.current_semifinalist_certificates.any?
  end

  def gets_semifinalist_certificate?
    team.submission.semifinalist?
  end

  def needs_appreciation_certificate?
    gets_appreciation_certificate? &&
      account.current_appreciation_certificates.count < account.mentor_profile.current_teams.count
  end

  def gets_appreciation_certificate?
    account.mentor_profile.present? &&
      account.mentor_profile.current_teams.any?
  end
end