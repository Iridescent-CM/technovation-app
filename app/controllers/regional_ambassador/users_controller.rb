module RegionalAmbassador
  class UsersController < RegionalAmbassadorController
    def show
      @account = Account.find(params[:id])
    end
  end
end
