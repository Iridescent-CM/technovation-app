module RegionalAmbassador
  class ExportsController < RegionalAmbassadorController
    def create
      RegionalExportJob.perform_later(current_ambassador, params.to_unsafe_h) # TODO: research the unsupported argument type ActionController::Parameters error
      redirect_back fallback_location: regional_ambassador_dashboard_path,
        success: t("controllers.exports.create.success")
    end
  end
end
