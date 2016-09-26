module Admin
  class AccountsController < AdminController
    def index
      accounts = SearchAccounts.(params)
      @accounts = accounts.paginate(per_page: params[:per_page], page: params[:page])
    end

    def show
      @account = Account.find(params[:id])
    end
  end
end
