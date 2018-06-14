require "./app/technovation/friendly_country"

class CertificateRecipient
  MAXIMUM_SCORES_FOR_GENERAL_JUDGE = 4

  attr_reader :account, :team,
    :id, :mobile_app_name, :full_name,
    :team_name, :region, :team_id

  def initialize(account, team = nil)
    if team
      @team = team
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

  def needed_certificate_types
    types = []
    types.push("participation")       if needs_participation_certificate?
    types.push("completion")          if needs_completion_certificate?
    types.push("semifinalist")        if needs_semifinalist_certificate?
    types.push("mentor_appreciation") if needs_appreciation_certificate?
    types.push("general_judge")       if needs_general_judge_certificate?
    types
  end

  def certificate_types
    types = []
    types.push("participation")       if gets_participation_certificate?
    types.push("completion")          if gets_completion_certificate?
    types.push("semifinalist")        if gets_semifinalist_certificate?
    types.push("mentor_appreciation") if gets_appreciation_certificate?
    types.push("general_judge")       if gets_general_judge_certificate?
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
    !!team &&
      team.submission.complete? &&
        team.submission.quarterfinalist?
  end

  def needs_participation_certificate?
    gets_participation_certificate? &&
      !account.current_participation_certificates.any?
  end

  def gets_participation_certificate?
    !!team && team.submission.qualifies_for_participation?
  end

  def needs_semifinalist_certificate?
    gets_semifinalist_certificate? &&
      !account.current_semifinalist_certificates.any?
  end

  def gets_semifinalist_certificate?
    !!team && team.submission.semifinalist?
  end

  def needs_appreciation_certificate?
    gets_appreciation_certificate? &&
      account.current_appreciation_certificates.count < account.mentor_profile.current_teams.count
  end

  def gets_appreciation_certificate?
    account.mentor_profile.present? &&
      account.mentor_profile.current_teams.any?
  end

  def needs_general_judge_certificate?
    gets_general_judge_certificate? &&
      !account.current_general_judge_certificates.any?
  end

  def gets_general_judge_certificate?
    !!account.judge_profile &&
      account.judge_profile.current_completed_scores.any? &&
        account.judge_profile.current_completed_scores.count <= MAXIMUM_SCORES_FOR_GENERAL_JUDGE
  end
end