module RegionalAmbassador
  class AccountsController < RegionalAmbassadorController
    def index
      @accounts_grid = AccountsGrid.new(accounts_grid_params) do |scope|
        scope.in_region(current_ambassador).page(params[:page])
      end
    end

    def show
      @account = Account.find(params[:id])
    end

    private
    def accounts_grid_params
      params[:accounts_grid] ||= {}

      if scope_name = params[:scope]
        params[:accounts_grid][:scope_names] = [scope_name]
      end

      params[:accounts_grid].merge(ambassador: current_ambassador)
    end
  end
end
