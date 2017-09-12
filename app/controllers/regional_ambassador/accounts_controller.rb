module RegionalAmbassador
  class AccountsController < RegionalAmbassadorController
    def index
      scope_name = params.fetch(:scope) { "student" }
      profile_table_name = "#{scope_name}_profiles"

      @accounts_grid = AccountsGrid.new(params[:accounts_grid]) do |scope|
        scope.where("#{profile_table_name}.id IS NOT NULL")
          .in_region(current_ambassador)
          .page(params[:page])
      end
    end

    def show
      @account = Account.find(params[:id])
    end
  end
end
