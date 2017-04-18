module RegionalAmbassador
  class ExportsController < RegionalAmbassadorController
    def create
      RegionalExportJob.perform_later(current_ambassador, params.to_h) # TODO: research the unsupported argument type ActionController::Parameters error
      redirect_to :back, success: t("controllers.exports.create.success")
    end
  end
end
