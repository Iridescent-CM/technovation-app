class ClubAmbassadorProfileAddition
  def initialize(account:)
    @account = account
  end

  def call
    if account.mentor_profile.present?
      create_club_ambassador_profile
      setup_club_ambassador_profile_in_crm

      Result.new(success?: true, message: {success: "#{account.name} now has a Club Ambassador profile"})
    else
      Result.new(success?: false, message: {error: "This account does not have a mentor profile"})
    end
  rescue ActiveRecord::RecordInvalid => invalid
    error_message = invalid.record.errors.full_messages.join(" , ")
    Result.new(success?: false, message: {error: "Error adding club ambassador profile - #{error_message}"})
  end

  private

  Result = Struct.new(:success?, :message, keyword_init: true)

  attr_reader :account

  def create_club_ambassador_profile
    account.create_club_ambassador_profile!({
      job_title: account.mentor_profile.job_title
    })
  end

  def setup_club_ambassador_profile_in_crm
    if ENV.fetch("ACTIVE_JOB_BACKEND", "inline") == "inline"
      CRM::SetupAccountForCurrentSeasonJob.perform_later(
        account_id: account.id,
        profile_type: "club ambassador"
      )
    else
      CRM::SetupAccountForCurrentSeasonJob
        .set(wait: 6.minutes)
        .perform_later(
          account_id: account.id,
          profile_type: "club ambassador"
        )
    end
  end
end
