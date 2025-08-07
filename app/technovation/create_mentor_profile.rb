module CreateMentorProfile
  def self.call(account, **options) # standard:disable all
    if account.can_be_a_mentor?(**options)  # standard:disable all

      attrs = setup_attributes(account)
      account.create_mentor_profile!(attrs)
      setup_mentor_profile_in_crm(account.id)

    else
      false
    end
  end

  private

  def self.setup_attributes(account)
    if account.chapter_ambassador_profile.present?
      {
        school_company_name: account.chapter_ambassador_profile
          .organization_company_name.presence || account.chapter_ambassador_profile.chapter.organization_name,
        job_title: account.chapter_ambassador_profile.job_title,
        mentor_type_ids: [MentorType.find_by(name: "Industry professional")&.id]
      }
    elsif account.club_ambassador_profile.present?
      {
        school_company_name: account.club_ambassador_profile.club.name,
        job_title: account.club_ambassador_profile.job_title,
        mentor_type_ids: [MentorType.find_by(name: "Industry professional")&.id]
      }
    elsif account.judge_profile.present?
      {
        school_company_name: account.judge_profile.company_name,
        job_title: account.judge_profile.job_title,
        mentor_type_ids: [MentorType.find_by(name: "Industry professional")&.id]
      }
    else
      {
        school_company_name: account.student_profile.school_name,
        job_title: "Past Technovation student",
        mentor_type_ids: [MentorType.find_by(name: "Past Technovation student")&.id]
      }
    end
  end

  def self.setup_mentor_profile_in_crm(account_id)
    CRM::SetupAccountForCurrentSeasonJob.perform_later(
      account_id: account_id,
      profile_type: "mentor"
    )
  end
end
