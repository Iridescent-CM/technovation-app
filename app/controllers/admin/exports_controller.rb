module Admin
  class ExportsController < AdminController
    def create
      ExportJob.perform_later(current_admin, params)
      cookies.permanent[:export_email] = params[:export_email]
      redirect_to :back, success: t("controllers.exports.create.success")
    end
  end
end
