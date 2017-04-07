class RemoveForeignKeyFromJoinRequests < ActiveRecord::Migration[4.2]
  def up
    logger = Logger.new("log/accounts-profiles-migrations-up.log")

    remove_foreign_key :join_requests, column: :requestor_id

    JoinRequest.find_each do |j|
      logger.info ""
      logger.info "------------------------------------------------------------------"

      student_profile = StudentProfile.find_by(account_id: j.requestor_id)
      mentor_profile = MentorProfile.find_by(account_id: j.requestor_id)

      if student_profile
        j.update_columns(requestor_id: student_profile.id,
                         requestor_type: "StudentProfile")
        logger.info "Student #{j.requestor_email} assigned as requestor to JoinRequest##{j.id}"
      elsif mentor_profile
        j.update_columns(requestor_id: mentor_profile.id,
                         requestor_type: "MentorProfile")
        logger.info "Mentor #{j.requestor_email} assigned as requestor to JoinRequest##{j.id}"
      else
        binding.pry
      end

      logger.info "------------------------------------------------------------------"
      logger.info ""
    end
  end

  def down
    logger = Logger.new("log/accounts-profiles-migrations-down.log")

    JoinRequest.find_each do |j|
      logger.info ""
      logger.info "------------------------------------------------------------------"

      student_profile = StudentProfile.find_by(id: j.requestor_id)
      mentor_profile = MentorProfile.find_by(id: j.requestor_id)

      j.update_columns(requestor_id: (student_profile || mentor_profile).account_id,
                       requestor_type: j.requestor_type.sub("Profile", "Account"))
      logger.info "#{j.requestor_type} #{j.requestor_email} assigned as requestor to JoinRequest##{j.id}"

      logger.info "------------------------------------------------------------------"
      logger.info ""
    end

    add_foreign_key :join_requests, :accounts, column: :requestor_id
  end
end
