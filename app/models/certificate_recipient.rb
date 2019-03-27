require "./app/constants/certificate_types"
require "./app/constants/badge_levels"
require "./app/models/friendly_country"
require "./app/null_objects/null_team"

class CertificateRecipient
  attr_reader :account, :team,
    :id, :mobile_app_name, :full_name,
    :team_name, :region, :team_id, :season

  def initialize(account, **options)
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
    if !!account.override_certificate_type
      String(certificate_type) === String(CERTIFICATE_TYPES[account.override_certificate_type])
    else
      send("gets_#{certificate_type}_certificate?")
    end
  end

  def needs_certificate?(certificate_type)
    gets_certificate?(certificate_type) &&
      send("needs_#{certificate_type}_certificate?")
  end

  def certificates
    certificate_types.map { |certificate_type|
      account.certificates
             .by_season(season)
             .public_send(certificate_type)
             .last
    }.compact
  end

  def certificate_url
    raise 'Recipient must be a judge' unless account.judge_profile.present?
    !!account.certificates.by_season(season).last &&
      account.certificates.by_season(season).last.file_url
  end

  def certificate_type
    if !!account.override_certificate_type
      account.override_certificate_type
    else
      CERTIFICATE_TYPES.find_index(certificate_types.last)
    end
  end

  def string_certificate_type
    if !!account.override_certificate_type
      CERTIFICATE_TYPES[account.override_certificate_type]
    else
      certificate_types.last
    end
  end

  def valid?
    certificate_types.any?
  end

  def judge_certificate_level(season = Season.current.year)
    return "" if !account.judge_profile.present?

    scores = account.judge_profile.completed_scores.by_season(season)

    if !!account.override_certificate_type
      CERTIFICATE_TYPES[account.override_certificate_type].humanize.titleize
    elsif scores.any? && scores.count <= MAXIMUM_SCORES_FOR_GENERAL_JUDGE
      "General Judge"
    elsif scores.any? && scores.count == NUMBER_OF_SCORES_FOR_CERTIFIED_JUDGE
      "Certified Judge"
    elsif scores.count <= MAXIMUM_SCORES_FOR_HEAD_JUDGE &&
            (judge.events.any? || scores.count >= MINIMUM_SCORES_FOR_HEAD_JUDGE)
      "Head Judge"
    elsif scores.count >= MINIMUM_SCORES_FOR_JUDGE_ADVISOR
      "Judge Advisor"
    else
      ""
    end
  end

  private
  def needs_completion_certificate?
    !account.completion_certificates.by_season(season).any?
  end

  def gets_completion_certificate?
    !team.nil? &&
      team.submission.complete? &&
        team.submission.quarterfinalist?
  end

  def needs_participation_certificate?
    !account.participation_certificates.by_season(season).any?
  end

  def gets_participation_certificate?
    !team.nil? && team.submission.qualifies_for_participation?
  end

  def needs_semifinalist_certificate?
    !account.semifinalist_certificates.by_season(season).any?
  end

  def gets_semifinalist_certificate?
    account.student_profile.present? &&
      !team.nil? && team.submission.semifinalist?
  end

  def needs_mentor_appreciation_certificate?
    account.appreciation_certificates.by_season(season).count <
      account.mentor_profile.teams.by_season(season).count
  end

  def gets_mentor_appreciation_certificate?
    account.mentor_profile.present? &&
      account.mentor_profile.teams.by_season(season).any?
  end

  def needs_general_judge_certificate?
    !account.general_judge_certificates.by_season(season).any?
  end

  def gets_general_judge_certificate?
    !!account.judge_profile &&
      account.judge_profile.completed_scores.by_season(season).any? &&
        account.judge_profile.completed_scores.by_season(season).count <= MAXIMUM_SCORES_FOR_GENERAL_JUDGE
  end

  def needs_certified_judge_certificate?
    !account.certified_judge_certificates.by_season(season).any?
  end

  def gets_certified_judge_certificate?
    !!account.judge_profile &&
      account.judge_profile.completed_scores.by_season(season).any? &&
        account.judge_profile.completed_scores.by_season(season).count == NUMBER_OF_SCORES_FOR_CERTIFIED_JUDGE
  end

  def needs_head_judge_certificate?
    !account.head_judge_certificates.by_season(season).any?
  end

  def gets_head_judge_certificate?
    !!account.judge_profile &&
      account.judge_profile.completed_scores.by_season(season).count <= MAXIMUM_SCORES_FOR_HEAD_JUDGE &&
        (account.judge_profile.events.any? ||
          account.judge_profile.completed_scores.by_season(season).count >= MINIMUM_SCORES_FOR_HEAD_JUDGE)
  end

  def needs_judge_advisor_certificate?
    !account.judge_advisor_certificates.by_season(season).any?
  end

  def gets_judge_advisor_certificate?
    !!account.judge_profile &&
      account.judge_profile.completed_scores.by_season(season).count >= MINIMUM_SCORES_FOR_JUDGE_ADVISOR
  end

  def gets_rpe_winner_certificate?
    false
  end

  def needs_rpe_winner_certificate?
    false
  end
end