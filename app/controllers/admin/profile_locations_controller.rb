module Admin
  class ProfileLocationsController < AdminController
    def edit
      @account = Account.find(params[:id])
      @profile = @account.send("#{@account.scope_name}_profile")
    end
  end
end
