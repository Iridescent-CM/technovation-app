class AddInviterTypeToTeamMemberInvites < ActiveRecord::Migration[4.2]
  def up
    logger = Logger.new("log/accounts-profiles-migrations-up.log")

    add_column :team_member_invites, :inviter_type, :string

    TeamMemberInvite.find_each do |t|
      logger.info ""
      logger.info "------------------------------------------------------------------"

      student_profile = StudentProfile.find_by(account_id: t.inviter_id)
      mentor_profile = MentorProfile.find_by(account_id: t.inviter_id)

      if student_profile
        t.update_columns(inviter_type: "StudentProfile",
                         inviter_id: student_profile.id)
        logger.info "Student #{t.inviter_email} assigned as inviter to TeamMemberInvite##{t.id}"
      elsif mentor_profile
        t.update_columns(inviter_type: "MentorProfile",
                         inviter_id: mentor_profile.id)
        logger.info "Mentor #{t.inviter_email} assigned as inviter to TeamMemberInvite##{t.id}"
      else
        logger.info "Account##{t.inviter_id} NOT FOUND"
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

      t.update_column(:inviter_id, t.inviter.account_id)
      logger.info "Account #{t.inviter_email} assigned as inviter to TeamMemberInvite##{t.id}"

      logger.info "------------------------------------------------------------------"
      logger.info ""
    end

    remove_column :team_member_invites, :inviter_type
  end
end
