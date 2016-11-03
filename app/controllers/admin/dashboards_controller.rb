module Admin
  class DashboardsController < AdminController
    def show
      execute_search
      execute_snapshot
    end

    private
    def execute_snapshot
      @snapshot_accounts = Account.current
      @snapshot_teams = Team.current
      @snapshot_students = StudentProfile.current
      @snapshot_mentors = MentorProfile.current
      @snapshot_ambassadors = RegionalAmbassadorProfile.current
      @snapshot_judges = JudgeProfile.current
      @snapshot_signups = SignupAttempt.all
    end

    def execute_search
      params[:days] = 7 if params[:days].blank?
      params[:days] = params[:days].to_i

      accounts = Account.current.where("season_registrations.created_at > ?", params[:days].days.ago)

      @students = accounts.joins(:student_profile)
      @permitted_students = StudentProfile.current
        .joins(:parental_consent)
        .where("parental_consents.created_at > ?", params[:days].days.ago)

      @mentors = accounts.joins(:mentor_profile)
      @cleared_mentors = MentorProfile.current
        .joins(:consent_waiver)
        .includes(:background_check)
        .where(
          "(accounts.country = ? AND background_checks.status = ? AND background_checks.created_at > ?)
          OR
          (accounts.country != ? AND consent_waivers.created_at > ?)",
          "US",
          BackgroundCheck.statuses[:clear],
          params[:days].days.ago,
          "US",
          params[:days].days.ago
        )

      @ambassadors = accounts.joins(:regional_ambassador_profile)

      @judges = accounts.joins(:judge_profile)

      @teams = Team.current.where("season_registrations.created_at > ?", params[:days].days.ago)
    end
  end
end
