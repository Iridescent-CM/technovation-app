module Admin
  class BackgroundChecksController < AdminController
    def index
      params[:status] = "pending" if params[:status].blank?
      params[:per_page] = 25 if params[:per_page].blank?

      @background_checks = BackgroundCheck.send(params[:status])
                                          .paginate(per_page: params[:per_page],
                                                    page: params[:page])
    end
  end
end
