class MergeRAMentors
  def initialize(filepath)
    @mergers = CSV.parse(
      File.read(filepath),
      headers: true
    )
  end

  def perform
    @mergers.each do |merger|
      ra = Account.find_by(email: merger["ra_email"])

      mentor = MentorProfile.joins(:account)
        .where("accounts.email = ?", merger["mentor_email"])
        .first

      ra.create_mentor_profile!({
        school_company_name: mentor.school_company_name,
        job_title: mentor.job_title,
        bio: mentor.bio,
        searchable: mentor.searchable,
        accepting_team_invites: mentor.accepting_team_invites,
        virtual: mentor.virtual,
        connect_with_mentors: mentor.connect_with_mentors,
      })

      mentor.account.destroy

      ra.update(
        email: merger["desired_email"],
        skip_existing_password: true
      )
    end
  end
end
