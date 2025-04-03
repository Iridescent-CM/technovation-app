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
end
