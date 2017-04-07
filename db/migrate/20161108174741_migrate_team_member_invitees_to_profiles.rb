class MigrateTeamMemberInviteesToProfiles < ActiveRecord::Migration[4.2]
  def up
    logger = Logger.new("log/accounts-profiles-migrations-up.log")

    TeamMemberInvite.find_each do |t|
      logger.info ""
      logger.info "------------------------------------------------------------------"

      student_profile = StudentProfile.find_by(account_id: t.invitee_id)
      mentor_profile = MentorProfile.find_by(account_id: t.invitee_id)

      if student_profile
        t.update_columns(invitee_type: "StudentProfile",
                         invitee_id: student_profile.id)
        logger.info "Student #{t.invitee_email} assigned as invitee to TeamMemberInvite##{t.id}"
      elsif mentor_profile
        t.update_columns(invitee_type: "MentorProfile",
                         invitee_id: mentor_profile.id)
        logger.info "Mentor #{t.invitee_email} assigned as invitee to TeamMemberInvite##{t.id}"
      else
        logger.info "Account##{t.invitee_id} NOT FOUND"
      end

      logger.info "------------------------------------------------------------------"
      logger.info ""
    end
  end

  def down
    logger = Logger.new("log/accounts-profiles-migrations-down.log")

    TeamMemberInvite.find_each do |t|
      logger.info ""
      logger.info "------------------------------------------------------------------"

      t.update_column(:invitee_id, t.invitee.account_id)
      logger.info "Account #{t.invitee_email} assigned as invitee to TeamMemberInvite##{t.id}"

      logger.info "------------------------------------------------------------------"
      logger.info ""
    end
  end
end
