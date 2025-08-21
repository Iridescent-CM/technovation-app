class DetermineCertificates
  private

  attr_reader :account

  public

  def initialize(account, options = {})
    @account = account
  end

  def eligible_types
    types = CertificateTypes::CERTIFICATE_TYPES.keys.select do |certificate_type|
      gets_certificate?(certificate_type)
    end

    types.map(&:to_s)
  end

  def needed
    needed = []

    eligible_types.select do |certificate_type|
      needed += needed_recipients(certificate_type)
    end

    needed
  end

  private

  def season
    Season.current.year
  end

  def gets_certificate?(certificate_type)
    send(:"gets_#{certificate_type}_certificate?")
  end

  def needed_recipients(certificate_type)
    send(:"needed_#{certificate_type}_recipients")
  end

  def gets_quarterfinalist_certificate?
    return false if !@account.student?

    team = @account.student_profile.team
    !team.nil? &&
      team.submission.complete? &&
      team.submission.quarterfinalist?
  end

  def needed_quarterfinalist_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:quarterfinalist, @account, team: @account.student_profile.team)]
    end
  end

  def gets_participation_certificate?
    return false if !@account.student?

    team = @account.student_profile.team
    !team.nil? && team.submission.qualifies_for_participation?
  end

  def needed_participation_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:participation, @account, team: @account.student_profile.team)]
    end
  end

  def gets_semifinalist_certificate?
    return false if !@account.student?

    team = @account.student_profile.team
    !team.nil? && team.submission.semifinalist?
  end

  def needed_semifinalist_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:semifinalist, @account, team: @account.student_profile.team)]
    end
  end

  def gets_regional_honoree_certificate?
    return false if !@account.student?

    team = @account.student_profile.team
    !team.nil? && team.submission.regional_honoree?
  end

  def needed_regional_honoree_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:regional_honoree, @account, team: @account.student_profile.team)]
    end
  end

  def gets_special_prize_winner_certificate?
    return false if !@account.student?

    team = @account.student_profile.team
    !team.nil? && team.submission.special_prize_winner?
  end

  def needed_special_prize_winner_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:special_prize_winner, @account, team: @account.student_profile.team)]
    end
  end

  def gets_finalist_certificate?
    return false if !@account.student?

    team = @account.student_profile.team
    !team.nil? && team.submission.finalist?
  end

  def needed_finalist_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:finalist, @account, team: @account.student_profile.team)]
    end
  end

  def gets_grand_prize_winner_certificate?
    return false if !@account.student?

    team = @account.student_profile.team
    !team.nil? && team.submission.grand_prize_winner?
  end

  def needed_grand_prize_winner_recipients
    if @account.certificates.student_types.by_season(season).for_team(@account.student_profile.team).any?
      []
    else
      [CertificateRecipient.new(:grand_prize_winner, @account, team: @account.student_profile.team)]
    end
  end

  def gets_mentor_appreciation_certificate?
    @account.mentor_profile.present? &&
      @account.mentor_profile.teams.by_season(season).any?
  end

  def needed_mentor_appreciation_recipients
    @account.mentor_profile.teams.by_season(season).select { |team|
      !@account.appreciation_certificates.by_season(season).for_team(team).any? &&
        team.submission.percent_complete > 50
    }.map { |team|
      CertificateRecipient.new(:mentor_appreciation, @account, team: team)
    }
  end

  def gets_general_judge_certificate?
    false # Only valid for seasons before 2019
  end

  def gets_bronze_judge_certificate?
    @account.judge_profile.present? &&
      !@account.judge_profile.suspended? &&
      !@account.judge_profile.events.any? &&
      @account.judge_profile.completed_scores.by_season(season).any? &&
      @account.judge_profile.completed_scores.by_season(season).count == BadgeLevels::NUMBER_OF_SCORES_FOR_BRONZE_JUDGE
  end

  def needed_bronze_judge_recipients
    if @account.certificates.judge_types.by_season(season).any?
      []
    else
      [CertificateRecipient.new(:bronze_judge, @account)]
    end
  end

  def gets_silver_judge_certificate?
    @account.judge_profile.present? &&
      !@account.judge_profile.suspended? &&
      @account.judge_profile.completed_scores.by_season(season).count <= BadgeLevels::MAXIMUM_SCORES_FOR_SILVER_JUDGE &&
      (@account.judge_profile.events.any? ||
       @account.judge_profile.completed_scores.by_season(season).count >= BadgeLevels::MINIMUM_SCORES_FOR_SILVER_JUDGE)
  end

  def needed_silver_judge_recipients
    if @account.certificates.judge_types.by_season(season).any?
      []
    else
      [CertificateRecipient.new(:silver_judge, @account)]
    end
  end

  def gets_gold_judge_certificate?
    @account.judge_profile.present? &&
      !@account.judge_profile.suspended? &&
      @account.judge_profile.completed_scores.by_season(season).count >= BadgeLevels::MINIMUM_SCORES_FOR_GOLD_JUDGE
  end

  def needed_gold_judge_recipients
    if @account.certificates.judge_types.by_season(season).any?
      []
    else
      [CertificateRecipient.new(:gold_judge, @account)]
    end
  end

  def gets_rpe_winner_certificate?
    false # handled off platform
  end
end
