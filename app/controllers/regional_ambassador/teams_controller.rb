module RegionalAmbassador
  class TeamsController < RegionalAmbassadorController
    def index
      @teams = Team.without_mentor.paginate(per_page: 25, page: params[:page])
    end
  end
end
