module AmbassadorHelper
  def ambassador_can_view_participant_details?(ambassador:, participant_profile:)
    if ambassador.national_view?
      participant_profile.is_a_student? && Account.in_region(ambassador.chapter).exists?(id: participant_profile.account.id) ||
        participant_profile.is_a_mentor?
    else
      (participant_profile.is_a_student? && participant_profile.current_chapterable == ambassador.current_chapterable) || participant_profile.is_a_mentor?
    end
  end

  def ambassador_can_view_team_details?(ambassador:, team:)
    if ambassador.national_view?
      Team.in_region(ambassador.chapter).exists?(id: team.id)
    else
      team.student_chapterables.include?(ambassador.current_chapterable)
    end
  end

  def chapter_ambassador_masked_judge_name(score:, account: (current_account if respond_to?(:current_account)))
    return score.judge_name unless account&.chapter_ambassador_profile.present?

    judge_account = score.judge_profile&.account
    return score.judge_name unless judge_account

    first_name = judge_account.first_name.to_s.strip
    last_initial = judge_account.last_name.to_s.strip.first

    return score.judge_name if first_name.blank?

    [first_name, (last_initial.present? ? "#{last_initial}." : nil)]
      .compact
      .join(" ")
  end

  def chapter_ambassador_can_link_to_judge?(
    score:,
    ambassador: (current_ambassador if respond_to?(:current_ambassador)),
    account: (current_account if respond_to?(:current_account))
  )
    return true unless account&.chapter_ambassador_profile.present?
    return false unless ambassador&.chapter && score.judge_profile

    chapter_judge_ids_for(ambassador).include?(score.judge_profile.id)
  end

  private

  def chapter_judge_ids_for(ambassador)
    @chapter_judge_ids_for ||= {}
    @chapter_judge_ids_for[ambassador.id] ||= RegionalPitchEvent
      .by_chapter(ambassador.chapter.id)
      .joins(:judges)
      .distinct
      .pluck("judge_profiles.id")
  end
end
