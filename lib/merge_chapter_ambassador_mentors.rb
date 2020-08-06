class MergeChapterAmbassadorMentors
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

        @logger.info("Starting merge for #{merger["chapter_ambassador_email"]}")

        if merger["mentor_email"]
          @logger.info("Mentor email: #{merger["mentor_email"]}")
        elsif merger["judge_email"]
          @logger.info("Judge email: #{merger["mentor_email"]}")
        else
          raise "No judge or mentor email given"
        end

        @logger.info("Desired email: #{merger["desired_email"]}")

        @logger.info("------------------------------------------")

        chapter_ambassador = Account.joins(:chapter_ambassador_profile)
          .where("email ilike ?", "%#{merger["chapter_ambassador_email"]}%")
          .first || (
            raise ActiveRecord::RecordNotFound, "Chapter ambassador Email #{merger['chapter_ambassador_email']}"
          )

        @logger.info("Found chapter ambassador ##{chapter_ambassador.id} #{chapter_ambassador.full_name} with email: #{chapter_ambassador.email}")

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

          m = chapter_ambassador.build_mentor_profile({
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

          @logger.info("Created mentor profile for chapter ambassador ##{chapter_ambassador.id}")

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

          j = chapter_ambassador.create_judge_profile({
            company_name: judge.company_name,
            job_title: judge.job_title,
          })

          j.save(validate: false)

          @logger.info("------------------------------------------")

          @logger.info("Created judge profile for chapter ambassador ##{chapter_ambassador.id}")

          judge.account.destroy

          if JudgeProfile.exists?(judge.id)
            raise "Judge##{judge.id} not destroyed!"
          end

          @logger.info("Judge##{judge.id} destroyed!")
        end

        chapter_ambassador.update(
          email: merger["desired_email"],
          skip_existing_password: true
        )

        @logger.info("Chapter ambassador ##{chapter_ambassador.id} email updated to #{chapter_ambassador.email}")

        @logger.info("==========================================")
      end
    end
  end
end
