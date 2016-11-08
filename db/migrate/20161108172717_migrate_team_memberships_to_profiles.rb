class MigrateTeamMembershipsToProfiles < ActiveRecord::Migration
  def up
    logger = Logger.new("log/accounts-profiles-migrations-up.log")

    Membership.find_each do |m|
      logger.info ""
      logger.info "------------------------------------------------------------------"

      student_profile = StudentProfile.find_by(account_id: m.member_id)
      mentor_profile = MentorProfile.find_by(account_id: m.member_id)

      if student_profile || mentor_profile
        m.update_columns(member_id: (student_profile || mentor_profile).id,
                        member_type: (student_profile || mentor_profile).class.name)

        logger.info "#{m.member_type} #{m.member_email} assigned as member to Membership##{m.id}"
      else
        logger.info "Account##{m.member_id} NOT FOUND"
      end

      logger.info "------------------------------------------------------------------"
      logger.info ""
    end
  end

  def down
    logger = Logger.new("log/accounts-profiles-migrations-down.log")

    Membership.find_each do |m|
      logger.info ""
      logger.info "------------------------------------------------------------------"

      m.update_columns(member_id: m.member.account_id,
                       member_type: m.member_type.sub("Profile", "Account"))

      logger.info "#{m.member_type} #{m.member_email} assigned as member to Membership##{m.id}"

      logger.info "------------------------------------------------------------------"
      logger.info ""
    end
  end
end
