module Legacy
  module V2
    module RegionalAmbassador
      class TeamsController < RegionalAmbassadorController
        def index
          params[:division] ||= "All"
          params[:per_page] = 15 if params[:per_page].blank?
          params[:page] = 1 if params[:page].blank?

          @teams = RegionalTeam.(current_ambassador, params)
            .distinct
            .page(params[:page].to_i)
            .per_page(params[:per_page].to_i)

          if @teams.empty?
            @teams = @teams.page(1)
          end
        end

        def show
          @team = Team.find(params[:id])
        end
      end
    end
  end
end
