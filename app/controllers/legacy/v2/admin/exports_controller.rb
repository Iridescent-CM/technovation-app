module Admin
  class ExportsController < AdminController
    def create
      ExportJob.perform_later(current_admin, params.to_unsafe_h) # TODO: research the unsupported argument type ActionController::Parameters error
      cookies.permanent[:export_email] = params[:export_email]
      redirect_back fallback_location: admin_dashboard_path,
        success: t("controllers.exports.create.success")
    end
  end
end
