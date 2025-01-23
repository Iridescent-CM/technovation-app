class ChapterAmbassadorProfileAddition
  def initialize(account:)
    @account = account
  end

  def call
    if account.mentor_profile.present?
      create_chapter_ambassador_profile
      setup_chapter_ambassador_profile_in_crm

      Result.new(success?: true, message: {success: "#{account.name} now has a Chapter Ambassador profile"})
    else
      Result.new(success?: false, message: {error: "This account does not have a mentor profile"})
    end
  rescue ActiveRecord::RecordInvalid => invalid
    error_message = invalid.record.errors.full_messages.join(" , ")
    Result.new(success?: false, message: {error: "Error adding chapter ambassador profile - #{error_message}"})
  end

  private

  Result = Struct.new(:success?, :message, keyword_init: true)

  attr_reader :account

  def create_chapter_ambassador_profile
    account.create_chapter_ambassador_profile!({
      organization_company_name: account.mentor_profile.school_company_name,
      job_title: account.mentor_profile.job_title,
      bio: account.mentor_profile.bio
    })
  end

  def setup_chapter_ambassador_profile_in_crm
    if ENV.fetch("ACTIVE_JOB_BACKEND", "inline") == "inline"
      CRM::SetupAccountForCurrentSeasonJob.perform_later(
        account_id: account.id,
        profile_type: "chapter ambassador"
      )
    else
      CRM::SetupAccountForCurrentSeasonJob
        .set(wait: 4.minutes)
        .perform_later(
          account_id: account.id,
          profile_type: "chapter ambassador"
        )
    end
  end
end
