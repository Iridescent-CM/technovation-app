module Admin
  class ClubsController < AdminController
    include DatagridController
    use_datagrid with: ClubsGrid

    def show
      @club = Club.find(params[:id])
    end

    def new
      @club = Club.new
    end

    def create
      club = Club.new(
        club_params.merge(seasons: [Season.current.year])
      )

      if club.save
        redirect_to admin_club_path(club), success: "#{club.name} was added as a new club."
      else
        render :new
      end
    end

    def edit
      @club = Club.find(params.fetch(:id))
    end

    def update
      @club = Club.find(params.fetch(:id))

      if @club.update(club_params)
        redirect_to admin_club_path(@club), success: "Club updated successfully."
      else
        render :edit
      end
    end

    private

    def club_params
      params.require(:club).permit(
        :id,
        :name,
        :summary
      )
    end

    def grid_params
      grid = params[:clubs_grid] ||= {}

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
