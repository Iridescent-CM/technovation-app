module Admin
  class ExportsController < AdminController
    def create
      ExportJob.perform_later(current_admin, params)
      redirect_to :back, success: t("controllers.exports.create.success")
    end
  end
end
