module Admin
  class CertificatesController < AdminController
    include DatagridController

    use_datagrid with: CertificatesGrid

    def show
      @certificate = Certificate.find(params.fetch(:id))
      @account = Account.find(@certificate.account_id)
    end

    def destroy
      certificate = Certificate.find(params[:id])
      account = Account.find(certificate.account_id)

      certificate.destroy

      redirect_to admin_certificates_path,
        success: "#{account.name} - #{certificate.description} was deleted"
    end

    private
    def grid_params
      grid = params[:certificates_grid] ||= {}
      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end
