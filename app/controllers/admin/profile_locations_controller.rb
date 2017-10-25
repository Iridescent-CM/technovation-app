module Admin
  class ProfileLocationsController < AdminController
    def edit
      @account = Account.find(params[:id])
    end
  end
end
