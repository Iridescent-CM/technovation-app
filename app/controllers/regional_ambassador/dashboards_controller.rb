module RegionalAmbassador
  class DashboardsController < RegionalAmbassadorController
    def show
      redirect_to regional_ambassador_participants_path if current_ambassador.approved?
    end
  end
end
