module Legacy
  module V2
    module Admin
      class ProfileLocationsController < AdminController
        def edit
          @account = Account.find(params[:id])
          @profile = @account.send("#{@account.type_name}_profile")
        end
      end
    end
  end
end
