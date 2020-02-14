task onboard_missed_students!: :environment do
  StudentProfile.current.onboarding.find_each do |student|
    if student.can_be_marked_onboarded?
      puts "Student##{student.id} should be onboarded"
      student.touch
    end
  end
end

task check_onboarding: :environment do
  logger = Logger.new("tmp/check_onboarding.log")

  logger.info("----- CHECKING ONBOARDED STUDENTS ------")
  StudentProfile.current.onboarded.includes(:signed_parental_consent, :account).find_each do |student|
    logger.info "checking Student##{student.id}"
    if student.signed_parental_consent.blank? or
         student.account.email_confirmed_at.blank? or
           !student.account.valid_coordinates?
      logger.error "Student##{student.id} FAILED"
      logger.error "Student##{student.id} parental consent is not signed" if student.signed_parental_consent.blank?
      logger.error "Student##{student.id} email is not confirmed" if student.account.email_confirmed_at.blank?
      logger.error "Student##{student.id} coordinates valid" if student.account.valid_coordinates?
      raise "#{student.id} IS NOT ONBOARDED BUT IS MARKED AS SO"
    end
    logger.info "Student##{student.id} PASSED"
  end

  logger.info("----- CHECKING ALL_STUDENTS_ONBOARDED TEAMS ------")
  Team.current.all_students_onboarded.includes(students: [:signed_parental_consent, :account]).references(:memberships).find_each do |team|
    logger.info "checking Team##{team.id}"
    failed = nil
    if team.students.any? do |student|
      if student.signed_parental_consent.blank? or
           student.account.email_confirmed_at.blank? or
             !student.account.valid_coordinates?
        failed = student
        true
      else
        false
      end
    end
      logger.error "Team##{team.id} FAILED"
      logger.error "Student##{failed.id} FAILED"
      logger.error "Student##{failed.id} parental consent is not signed" if failed.signed_parental_consent.blank?
      logger.error "Student##{failed.id} email is not confirmed" if failed.account.email_confirmed_at.blank?
      logger.error "Student##{student.id} coordinates valid" if failed.account.valid_coordinates?
      raise "#{team.id} IS NOT ALL STUDENTS ONBOARDED BUT IS MARKED AS SO --- Student##{failed.id}"
    end
    logger.info "Team##{team.id} PASSED"
  end

  logger.info("----- CHECKING NOT_ONBOARDED STUDENTS ------")
  StudentProfile.current.onboarding.includes(:signed_parental_consent, :account).find_each do |student|
    logger.info "checking Student##{student.id}"
    unless student.signed_parental_consent.blank? or
             student.account.email_confirmed_at.blank? or
               !student.account.valid_coordinates?
      logger.error "Student##{student.id} FAILED"
      logger.error "Student##{student.id} parental consent is signed" unless student.signed_parental_consent.blank?
      logger.error "Student##{student.id} email is confirmed" unless student.account.email_confirmed_at.blank?
      logger.error "Student##{student.id} coordinates valid" if student.account.valid_coordinates?
      raise "#{student.id} IS ONBOARDED BUT IS MARKED AS NOT SO"
    end
    logger.info "Student##{student.id} PASSED"
  end

  logger.info("----- CHECKING SOME_STUDENTS_ONBOARDING TEAMS ------")
  Team.current.some_students_onboarding.includes(students: [:signed_parental_consent, :account]).references(:memberships).find_each do |team|
    logger.info "checking Team##{team.id}"
    failed = nil
    if not team.students.any? do |student|
      if student.signed_parental_consent.blank? or
           student.account.email_confirmed_at.blank? or
             !student.account.valid_coordinates?
        true
      else
        failed = student
        false
      end
    end
      logger.error "Team##{team.id} FAILED"
      logger.error "Student##{failed.id} FAILED"
      logger.error "Student##{failed.id} parental consent is signed" unless failed.signed_parental_consent.blank?
      logger.error "Student##{failed.id} email is confirmed" unless failed.account.email_confirmed_at.blank?
      logger.error "Student##{failed.id} coordinates valide" if failed.account.valid_coordinates?
      raise "#{team.id} IS NOT SOME STUDENTS ONBOARDING BUT IS MARKED AS SO --- Student##{student.id}"
    end
    logger.info "Team##{team.id} PASSED"
  end

  logger.info "All teams / students marked as onboarded appear to be so"
  $stdout = STDOUT
end