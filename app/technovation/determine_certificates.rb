require "./app/constants/badge_levels"

class DetermineCertificates
  private
  attr_reader :account

  public
  def initialize(account, options = {})
    @account = account
  end

  def eligible_types
    CERTIFICATE_TYPES.select do |certificate_type|
      gets_certificate?(certificate_type)
    end
  end

  def needed
    needed = []

    eligible_types.each do |certificate_type|
      needed += needed_recipients(certificate_type)
    end

    return needed
  end

  private
  def season
    Season.current.year
  end

  def eligible_certificate_types
    CERTIFICATE_TYPES.select do |certificate_type|
      gets_certificate?(certificate_type, @account)
    end
  end

  def gets_certificate?(certificate_type)
    send("gets_#{certificate_type}_certificate?")
  end

  def needed_recipients(certificate_type)
    send("needed_#{certificate_type}_recipients")
  end

  def gets_completion_certificate?
    return false if !@account.student_profile.present?

    team = @account.student_profile.team
    return !team.nil? &&
      team.submission.complete? &&
        team.submission.quarterfinalist?
  end

  def needed_completion_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:completion, @account, team: @account.student_profile.team)]
    end
  end
  
  def gets_participation_certificate?
    return false if !@account.student_profile.present?

    team = @account.student_profile.team
    return !team.nil? && team.submission.qualifies_for_participation?
  end

  def needed_participation_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:participation, @account, team: @account.student_profile.team)]
    end
  end
  
  def gets_semifinalist_certificate?
    return false if !@account.student_profile.present?

    team = @account.student_profile.team
    return !team.nil? && team.submission.semifinalist?
  end

  def needed_semifinalist_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:semifinalist, @account, team: @account.student_profile.team)]
    end
  end
  
  def gets_mentor_appreciation_certificate?
    @account.mentor_profile.present? &&
      @account.mentor_profile.teams.by_season(season).any?
  end

  def needed_mentor_appreciation_recipients
    @account.mentor_profile.teams.by_season(season).select { |team|
      !@account.appreciation_certificates.by_season(season).for_team(team).any?
    }.map { |team|
      CertificateRecipient.new(:mentor_appreciation, @account, team: team)
    }
  end

  def gets_general_judge_certificate?
    @account.judge_profile.present? &&
      !@account.judge_profile.events.any? &&
        @account.judge_profile.completed_scores.by_season(season).any? &&
          @account.judge_profile.completed_scores.by_season(season).count <= MAXIMUM_SCORES_FOR_GENERAL_JUDGE
  end

  def needed_general_judge_recipients
    if @account.certificates.judge_types.by_season(season).any?
      []
    else
      [CertificateRecipient.new(:general_judge, @account)]
    end
  end

  def gets_certified_judge_certificate?
    @account.judge_profile.present? &&
      !@account.judge_profile.events.any? &&
        @account.judge_profile.completed_scores.by_season(season).any? &&
          @account.judge_profile.completed_scores.by_season(season).count == NUMBER_OF_SCORES_FOR_CERTIFIED_JUDGE
  end

  def needed_certified_judge_recipients
    if @account.certificates.judge_types.by_season(season).any?
      []
    else
      [CertificateRecipient.new(:certified_judge, @account)]
    end
  end

  def gets_head_judge_certificate?
    @account.judge_profile.present? &&
      @account.judge_profile.completed_scores.by_season(season).count <= MAXIMUM_SCORES_FOR_HEAD_JUDGE &&
        (@account.judge_profile.events.any? ||
          @account.judge_profile.completed_scores.by_season(season).count >= MINIMUM_SCORES_FOR_HEAD_JUDGE)
  end

  def needed_head_judge_recipients
    if @account.certificates.judge_types.by_season(season).any?
      []
    else
      [CertificateRecipient.new(:head_judge, @account)]
    end
  end

  def gets_judge_advisor_certificate?
    @account.judge_profile.present? &&
      @account.judge_profile.completed_scores.by_season(season).count >= MINIMUM_SCORES_FOR_JUDGE_ADVISOR
  end

  def needed_judge_advisor_recipients
    if @account.certificates.judge_types.by_season(season).any?
      []
    else
      [CertificateRecipient.new(:judge_advisor, @account)]
    end
  end

  def gets_rpe_winner_certificate?
    false # handled off platform
  end
end
