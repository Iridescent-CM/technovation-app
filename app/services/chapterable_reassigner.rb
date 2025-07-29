class ChapterableReassigner
  def initialize(account:)
    @account = account
  end

  def call
    return if !account.is_a_mentor? && !account.is_a_student?
    return if account.assigned_to_chapterable?
    return if account.last_seasons_primary_chapterable_assignment.blank?
    return if account.last_seasons_primary_chapterable_assignment.chapterable.inactive?

    assign_account_to_last_seasons_chapterable
  end

  private

  attr_accessor :account

  def assign_account_to_last_seasons_chapterable
    account.chapterable_assignments.create!(
      profile: profile,
      chapterable: account.last_seasons_primary_chapterable_assignment.chapterable,
      season: Season.current.year,
      primary: true,
      assignment_by: account
    )
  end

  def profile
    account.mentor_profile || account.student_profile
  end
end
