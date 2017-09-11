module RegionalAmbassador
  class AccountsController < RegionalAmbassadorController
    def index
      @accounts_grid = AccountsGrid.new(params[:accounts_grid]) do |scope|
        scope.in_region(current_ambassador).page(params[:page])
      end
    end

    def show
      @account = Account.find(params[:id])
    end
  end
end
