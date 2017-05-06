module RegionalAmbassador
  class ExportsController < RegionalAmbassadorController
    def create
      RegionalExportJob.perform_later(current_ambassador, params.to_unsafe_h)
      redirect_back fallback_location: regional_ambassador_dashboard_path,
        success: t("controllers.exports.create.success")
    end
  end
end
