module Admin
  class BackgroundChecksController < AdminController
    def index
      params[:status] = "pending" if params[:status].blank?
      params[:page] = 1 if params[:page].blank?
      params[:per_page] = 15 if params[:per_page].blank?

      @background_checks = BackgroundCheck.send(params[:status])
                             .page(params[:page].to_i)
                             .per_page(params[:per_page].to_i)

      if @background_checks.empty?
        @background_checks = @background_checks.page(1)
      end
    end
  end
end
