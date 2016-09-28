module Admin
  class DashboardsController < AdminController
    def show
      params[:days] = 7 if params[:days].blank?
      params[:days] = params[:days].to_i

      @accounts = Account.current.where("season_registrations.created_at > ?", params[:days].days.ago)
      @students = @accounts.where(type: "StudentAccount")
      @mentors = @accounts.where(type: "MentorAccount")
      @ambassadors = @accounts.where(type: "RegionalAmbassadorAccount")
      @judges = @accounts.where(type: "JudgeAccount")
    end
  end
end
