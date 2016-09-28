module Admin
  class DashboardsController < AdminController
    def show
      params[:days] = 7 if params[:days].blank?
      params[:days] = params[:days].to_i

      @students = StudentAccount.current.where("season_registrations.created_at > ?", params[:days].days.ago)
      @mentors = MentorAccount.current.where("season_registrations.created_at > ?", params[:days].days.ago)
      @ambassadors = RegionalAmbassadorAccount.current.where("season_registrations.created_at > ?", params[:days].days.ago)
      @judges = JudgeAccount.current.where("season_registrations.created_at > ?", params[:days].days.ago)
    end
  end
end
