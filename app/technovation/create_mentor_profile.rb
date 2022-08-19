module CreateMentorProfile
  def self.call(account, **options)
    if account.can_be_a_mentor?(**options)
      attrs = setup_attributes(account)
      account.create_mentor_profile!(attrs)
    else
      false
    end
  end

  private
  def self.setup_attributes(account)
    if account.chapter_ambassador_profile.present?
      {
        school_company_name: account.chapter_ambassador_profile
          .organization_company_name,
        job_title: account.chapter_ambassador_profile.job_title,
        mentor_type: "Industry professional",
      }
    elsif account.judge_profile.present?
      {
        school_company_name: account.judge_profile.company_name,
        job_title: account.judge_profile.job_title,
        mentor_type: "Industry professional",
      }
    else
      {
        school_company_name: account.student_profile.school_name,
        job_title: "Technovation Alumnus",
        mentor_type: "Past Technovation student",
      }
    end
  end
end
