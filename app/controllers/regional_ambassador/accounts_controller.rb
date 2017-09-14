module RegionalAmbassador
  class AccountsController < RegionalAmbassadorController
    def index
      @unmatched_students = StudentProfile.unmatched
        .in_region(current_ambassador)
        .order(created_at: :desc)
        .limit(15)
    end

    def show
      @account = Account.find(params[:id])
    end

    private
    def accounts_grid_params
      params.fetch(:accounts_grid) { {} }.merge(ambassador: current_ambassador)
    end
  end
end
