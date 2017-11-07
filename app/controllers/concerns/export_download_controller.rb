module ExportDownloadController
  extend ActiveSupport::Concern

  def update
    export = Export.find(params[:id])
    export.update_column(:downloaded, true)
    render json: {}
  end
end
