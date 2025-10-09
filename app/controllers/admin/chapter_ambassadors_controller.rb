module Admin
  class ChapterAmbassadorsController < AdminController
    include DatagridController

    use_datagrid with: ChapterAmbassadorsGrid

    def show
      @chapter_ambassador = ChapterAmbassadorProfile.find_by(account_id: params.fetch(:id))
      @report = BackgroundCheck::Report.retrieve(@chapter_ambassador.background_check_report_id)
      @consent_waiver = @chapter_ambassador.consent_waiver
    end

    def update
      ambassador = ChapterAmbassadorProfile.find(params.fetch(:id))
      ambassador.public_send(:"#{params.fetch(:status)}!")
      redirect_back fallback_location: admin_chapter_ambassadors_path,
        success: "#{ambassador.full_name} was marked as #{params.fetch(:status)}"
    end

    def grid_params
      grid = params[:chapter_ambassadors_grid] ||= {}
      grid.merge(
        column_names: detect_extra_columns(grid),
        admin: true,
        allow_state_search: true,
        country: Array(params[:chapter_ambassadors_grid][:country]),
        state_province: Array(params[:chapter_ambassadors_grid][:state_province])
      )
    end
  end
end
