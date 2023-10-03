task remove_pending_team_invites_to_mentors: :environment do
  pending_team_invites_to_mentors = TeamMemberInvite
    .where(invitee_type: "MentorProfile", status: "pending")
    .where("created_at < '2023-07-01'")

  puts "Removing #{pending_team_invites_to_mentors.count} pending team invites"

  pending_team_invites_to_mentors.delete_all

  puts "Done"
end
