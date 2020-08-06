module CreateJudgeProfile
  def self.call(account)
    if account.can_be_a_judge? and account.is_not_a_judge?
      create_judge_profile(account)
      true
    else
      false
    end
  end

  private
  def self.create_judge_profile(account)
    attrs = if account.chapter_ambassador_profile.present?
              {
                company_name: account.chapter_ambassador_profile
                  .organization_company_name,
                job_title: account.chapter_ambassador_profile.job_title,
              }
            elsif account.mentor_profile.present?
              {
                company_name: account.mentor_profile.school_company_name,
                job_title: account.mentor_profile.job_title,
              }
            end

    account.create_judge_profile!(attrs)
  end
end
