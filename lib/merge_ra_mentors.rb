class MergeRAMentors
  def initialize(filepath, logger = "/dev/null")
    @mergers = CSV.parse(
      File.read(filepath),
      headers: true
    )
    @logger = Logger.new(logger)
  end

  def perform
    ActiveRecord::Base.transaction do
      @mergers.each do |merger|
        @logger.info("==========================================")

        @logger.info("Starting merge for #{merger["ra_email"]}")

        if merger["mentor_email"]
          @logger.info("Mentor email: #{merger["mentor_email"]}")
        elsif merger["judge_email"]
          @logger.info("Judge email: #{merger["mentor_email"]}")
        else
          raise "No judge or mentor email given"
        end

        @logger.info("Desired email: #{merger["desired_email"]}")

        @logger.info("------------------------------------------")

        ra = Account.joins(:regional_ambassador_profile)
          .where("email ilike ?", "%#{merger["ra_email"]}%")
          .first || (
            raise ActiveRecord::RecordNotFound, "RA Email #{merger['ra_email']}"
          )

        @logger.info("Found RA##{ra.id} #{ra.full_name} with email: #{ra.email}")

        if merger["mentor_email"]
          mentor = MentorProfile.joins(:account)
            .where("accounts.email ilike ?", "%#{merger["mentor_email"]}%")
            .first || (
              raise ActiveRecord::RecordNotFound,
                "Mentor Email #{merger['mentor_email']}"
            )

          @logger.info(
            "Found Mentor##{mentor.id} #{mentor.full_name} with email: #{mentor.email}"
          )

          m = ra.build_mentor_profile({
            school_company_name: mentor.school_company_name,
            job_title: mentor.job_title,
            mentor_type: mentor.mentor_type,
            bio: mentor.bio,
            searchable: mentor.searchable,
            accepting_team_invites: mentor.accepting_team_invites,
            virtual: mentor.virtual,
            connect_with_mentors: mentor.connect_with_mentors,
          })

          m.save(validate: false)

          @logger.info("------------------------------------------")

          @logger.info("Created mentor profile for RA##{ra.id}")

          mentor.account.destroy

          if MentorProfile.exists?(mentor.id)
            raise "Mentor##{mentor.id} not destroyed!"
          end

          @logger.info("Mentor##{mentor.id} destroyed!")
        else
          judge = JudgeProfile.joins(:account)
            .where("accounts.email ilike ?", "%#{merger["judge_email"]}%")
            .first || (
              raise ActiveRecord::RecordNotFound,
                "Judge Email #{merger['judge_email']}"
            )

          @logger.info(
            "Found Judge##{judge.id} #{judge.full_name} with email: #{judge.email}"
          )

          j = ra.create_judge_profile({
            company_name: judge.company_name,
            job_title: judge.job_title,
          })

          j.save(validate: false)

          @logger.info("------------------------------------------")

          @logger.info("Created judge profile for RA##{ra.id}")

          judge.account.destroy

          if JudgeProfile.exists?(judge.id)
            raise "Judge##{judge.id} not destroyed!"
          end

          @logger.info("Judge##{judge.id} destroyed!")
        end

        ra.update(
          email: merger["desired_email"],
          skip_existing_password: true
        )

        @logger.info("RA##{ra.id} email updated to #{ra.email}")

        @logger.info("==========================================")
      end
    end
  end
end
