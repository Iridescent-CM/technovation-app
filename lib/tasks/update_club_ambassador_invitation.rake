desc "Update club ambassador invitation"
task :update_club_ambassador_invitation, [:dry_run] => :environment do |t, args|
  dry_run = args[:dry_run] != "run"

  club_ambassador_invites = UserInvitation.where(profile_type: 1).where.not(club_id: nil)

  puts "DRY RUN: #{dry_run ? "on" : "off"}"
  puts("Updating profile type for #{club_ambassador_invites.count} club ambassador invites")

  if !dry_run
    puts("Starting update")
    club_ambassador_invites.find_each do |invite|
      puts("Updating invitation: ID: #{invite.id} | Email: #{invite.email}")
      invite.update_column(:profile_type, 5)
    end
    puts("Update complete")
  end
end
