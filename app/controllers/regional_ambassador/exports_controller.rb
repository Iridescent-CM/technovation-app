module RegionalAmbassador
  class ExportsController < RegionalAmbassadorController
    def create
      RegionalExportJob.perform_later(current_ambassador, params)
      redirect_to :back, success: t("controllers.exports.create.success")
    end
  end
end
