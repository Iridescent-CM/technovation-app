require "./app/constants/certificate_types"
require "./app/constants/badge_levels"
require "./app/technovation/friendly_country"

class CertificateRecipient
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

  def certificate_types
    CERTIFICATE_TYPES.select do |certificate_type|
      gets_certificate?(certificate_type)
    end
  end

  def needed_certificate_types
    certificate_types.select do |certificate_type|
      needs_certificate?(certificate_type)
    end
  end

  def gets_certificate?(certificate_type)
    send("gets_#{certificate_type}_certificate?")
  end

  def needs_certificate?(certificate_type)
    send("needs_#{certificate_type}_certificate?")
  end

  def certificates
    certificate_types.map { |certificate_type|
      account.certificates
             .current
             .public_send(certificate_type)
             .last
    }.compact
  end

  def certificate_url
    raise 'Recipient must be a judge' unless account.judge_profile.present?
    !!account.certificates.current.last &&
      account.certificates.current.last.file_url
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

  def needs_mentor_appreciation_certificate?
    gets_mentor_appreciation_certificate? &&
      account.current_appreciation_certificates.count < account.mentor_profile.current_teams.count
  end

  def gets_mentor_appreciation_certificate?
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

  def needs_certified_judge_certificate?
    gets_certified_judge_certificate? &&
      !account.current_certified_judge_certificates.any?
  end

  def gets_certified_judge_certificate?
    !!account.judge_profile &&
      account.judge_profile.current_completed_scores.any? &&
        account.judge_profile.current_completed_scores.count == NUMBER_OF_SCORES_FOR_CERTIFIED_JUDGE
  end

  def needs_head_judge_certificate?
    gets_head_judge_certificate? &&
      !account.current_head_judge_certificates.any?
  end

  def gets_head_judge_certificate?
    !!account.judge_profile &&
      account.judge_profile.current_completed_scores.count <= MAXIMUM_SCORES_FOR_HEAD_JUDGE &&
        (account.judge_profile.events.any? ||
          account.judge_profile.current_completed_scores.count >= MINIMUM_SCORES_FOR_HEAD_JUDGE)
  end

  def needs_judge_advisor_certificate?
    gets_judge_advisor_certificate? &&
      !account.current_judge_advisor_certificates.any?
  end

  def gets_judge_advisor_certificate?
    !!account.judge_profile &&
      account.judge_profile.current_completed_scores.count >= MINIMUM_SCORES_FOR_JUDGE_ADVISOR
  end

  def gets_rpe_winner_certificate?
    false
  end

  def needs_rpe_winner_certificate?
    false
  end
end