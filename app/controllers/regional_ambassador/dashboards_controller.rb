module RegionalAmbassador
  class DashboardsController < RegionalAmbassadorController
    def show
      redirect_to regional_ambassador_profile_path if current_ambassador.approved?
    end
  end
end
