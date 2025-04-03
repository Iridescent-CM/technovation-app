class MentorToTeamChapterableAssignerJob < ActiveJob::Base
  queue_as :default

  def perform(mentor_profile_id:, team_id:)
    mentor_profile = MentorProfile.find(mentor_profile_id)
    team = Team.find(team_id)

    MentorToTeamChapterableAssigner.new(mentor_profile: mentor_profile, team: team).call
  end
end
