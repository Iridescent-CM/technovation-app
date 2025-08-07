class StudentToMentorConverter
  def initialize(account:)
    @account = account
  end

  def call
    if account.student_profile.present?
      create_mentor_profile
      delete_pending_join_requests
      delete_team_memberships
      delete_student_profile

      register_mentor_to_current_season

      Result.new(success?: true, message: {success: "#{account.name} has been successfully converted to a mentor"})
    else
      Result.new(success?: false, message: {error: "This account does not have a student profile"})
    end
  rescue ActiveRecord::RecordNotUnique
    Result.new(success?: false, message: {error: "A mentor profile already exists for this account"})
  end

  private

  Result = Struct.new(:success?, :message, keyword_init: true)

  attr_reader :account

  def create_mentor_profile
    account.create_mentor_profile!({
      school_company_name: account.student_profile.school_name,
      job_title: "Past Technovation student",
      mentor_type_ids: [MentorType.find_by(name: "Past Technovation student").id],
      former_student: true
    })

    account.update_columns(gender: "Prefer not to say")
  end

  def delete_pending_join_requests
    account.student_profile&.join_requests&.pending&.delete_all
  end

  def delete_team_memberships
    account.student_profile&.memberships&.delete_all
  end

  def delete_student_profile
    account.student_profile&.delete
  end

  def register_mentor_to_current_season
    if ENV.fetch("ACTIVE_JOB_BACKEND", "inline") == "inline"
      RegisterToCurrentSeasonJob.perform_later(account)
    else
      RegisterToCurrentSeasonJob
        .set(wait: 8.minutes)
        .perform_later(account)
    end
  end
end
