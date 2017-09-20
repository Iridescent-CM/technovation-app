module CreateMentorProfile
  def self.call(account)
    if account.can_be_a_mentor? and account.is_not_a_mentor?
      create_mentor_profile(account)
      true
    else
      false
    end
  end

  private
  def self.create_mentor_profile(account)
    attrs = if account.regional_ambassador_profile.present?
              {
                school_company_name: account.regional_ambassador_profile
                  .organization_company_name,
                job_title: account.regional_ambassador_profile.job_title,
              }
            elsif account.judge_profile.present?
              {
                school_company_name: account.judge_profile.company_name,
                job_title: account.judge_profile.job_title,
              }
            end

    account.create_mentor_profile!(attrs)
  end
end
