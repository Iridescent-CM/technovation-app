module Admin
  class DashboardsController < AdminController
    def show
      @students = StudentProfile.current

      @mentors = Account.current.left_outer_joins(:mentor_profile)
        .where("mentor_profiles.id IS NOT NULL")
    end
  end
end
