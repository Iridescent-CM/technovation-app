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
      permitted = permitted_grid_params
      permitted.merge(
        column_names: detect_extra_columns(permitted),
        admin: true,
        allow_state_search: true,
        country: Array(permitted[:country]),
        state_province: Array(permitted[:state_province])
      )
    end
  end
end
