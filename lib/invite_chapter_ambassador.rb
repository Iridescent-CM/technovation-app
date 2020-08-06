module InviteChapterAmbassador
  def self.call(attrs, logger = "/dev/null")
    @logger = Logger.new(logger)

    @logger.info("============================================================")

    if attrs.respond_to?(:symbolize_keys!)
      attrs.symbolize_keys!
    end

    account = Account.find_by(email: attrs[:email])

    if account && account.approved_chapter_ambassador_profile
      @logger.info("SKIPPING #{attrs[:email]} - Approved chapter ambassador profile already found!")
      return
    end

    @logger.info("CREATING Approved chapter ambassador for #{attrs[:email]}")

    if attempt = SignupAttempt.find_by(email: attrs[:email])
      @logger.info("DESTROYING found SignupAttempt for #{attrs[:email]}")
      attempt.destroy
    end

    attempt = SignupAttempt.create!(
      email: attrs[:email],
      password: SecureRandom.hex(17),
      status: SignupAttempt.statuses[:temporary_password],
    )

    if account = Account.where("lower(email) = ?", attrs[:email].downcase).first
      background_check = account.background_check
      mentor_profile = account.mentor_profile
      @logger.info("DESTROYING found Account for #{attrs[:email]}")
      account.destroy
    end

    account = attempt.create_account!(
      email: attrs[:email],
      first_name: attrs[:first_name],
      last_name: attrs[:last_name],
      city: attrs[:city],
      state_province: attrs[:state_province],
      country: attrs[:country],
      date_of_birth: attrs[:date_of_birth],
      gender: "Prefer not to say",
      password: SecureRandom.hex(17),
      email_confirmed_at: Time.current,
      skip_existing_password: true,
    )

    if mentor_profile.present?
      @logger.info("ADDING found MentorProfile for #{attrs[:email]}")

      mentor_attrs = mentor_profile.attributes.reject do |k, _|
        %w{id account_id}.include?(k.to_s)
      end

      mentor_attrs = mentor_attrs.merge(bio: attrs[:bio])

      account.create_mentor_profile!(mentor_attrs)
    end

    if background_check.present?
      @logger.info("ADDING found BackgroundCheck for #{attrs[:email]}")
      account.create_background_check!({
        candidate_id: background_check.candidate_id,
        report_id: background_check.report_id,
        status: background_check.status,
      })
    end

    account.create_chapter_ambassador_profile!(
      organization_company_name: attrs[:organization_company_name],
      job_title: attrs[:job_title],
      bio: attrs[:bio],
      ambassador_since_year: "I'm new!",
      status: :approved,
    )

    @logger.info("READY to invite Approved chapter ambassador: #{account.reload.email}")
    attempt
  end
end
