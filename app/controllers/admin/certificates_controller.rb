module Admin
  class CertificatesController < AdminController
    include DatagridController

    use_datagrid with: CertificatesGrid

    def show
      @certificate = Certificate.find(params.fetch(:id))
      @account = Account.find(@certificate.account_id)
    end

    def create
      cert_type = params.fetch(:certificate_type)
      account = Account.find(params.fetch(:account_id))
      if team_id = params.fetch(:team_id) { false }
        team = Team.find(team_id)
      else
        team = nil
      end

      msg = nil
      if account.certificates.by_season(Season.current.year).for_team(team).for_cert_type(cert_type).empty?
        recipient = CertificateRecipient.new(cert_type, account, team: team)
        CertificateJob.perform_now(recipient.state)
        msg = {
          success: "Job started to award #{recipient.description}, it may take some time to appear"
        }
      else
        msg = {
          error: "Exist certificate"
        }
      end

      redirect_to admin_participant_path(account), msg
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
