module Admin
  class DashboardsController < AdminController
    def show
      params[:days] = 7 if params[:days].blank?
      params[:days] = params[:days].to_i

      accounts = Account.current.where("season_registrations.created_at > ?", params[:days].days.ago)

      @students = accounts.where(type: "StudentAccount")
      @permitted_students = StudentAccount.current
        .joins(:parental_consent)
        .where("parental_consents.created_at > ?", params[:days].days.ago)

      @mentors = accounts.where(type: "MentorAccount")
      @cleared_mentors = MentorAccount.current
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

      @ambassadors = accounts.where(type: "RegionalAmbassadorAccount")

      @judges = accounts.where(type: "JudgeAccount")

      @teams = Team.current.where("season_registrations.created_at > ?", params[:days].days.ago)
    end
  end
end
