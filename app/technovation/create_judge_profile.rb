module CreateJudgeProfile
  def self.call(account)
    if account.can_be_a_judge? && account.is_not_a_judge?
      create_judge_profile(account)
      setup_judge_profile_in_crm(account.id)

      true
    else
      false
    end
  end

  def self.create_judge_profile(account)
    attrs = if account.chapter_ambassador_profile.present?
      {
        company_name: account.chapter_ambassador_profile
          .organization_company_name,
        job_title: account.chapter_ambassador_profile.job_title
      }
    elsif account.mentor_profile.present?
      {
        company_name: account.mentor_profile.school_company_name,
        job_title: account.mentor_profile.job_title
      }
    end

    account.create_judge_profile!(attrs)
  end

  def self.setup_judge_profile_in_crm(account_id)
    CRM::SetupAccountForCurrentSeasonJob.perform_later(
      account_id: account_id,
      profile_type: "judge"
    )
  end

  private_class_method :create_judge_profile, :setup_judge_profile_in_crm
end
