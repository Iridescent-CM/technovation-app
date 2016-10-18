module Admin
  class AccountsController < AdminController
    def index
      accounts = SearchAccounts.(params)
      @accounts = accounts.paginate(per_page: params[:per_page], page: params[:page])
    end

    def show
      @account = Account.find(params[:id])
    end

    def edit
      @account = Account.find(params[:id])
    end

    def update
      @account = Account.find(params[:id])

      if @account.update_attributes(account_params)
        redirect_to admin_account_path(@account),
          success: "Account information saved"
      else
        render :edit
      end
    end

    private
    def account_params
      params.require("#{@account.type_name}_account").permit(
        :first_name,
        :last_name,
        :date_of_birth,
        :gender,
        :geocoded,
        :city,
        :state_province,
        :country,
        :latitude,
        :longitude,
        :profile_image,
        :profile_image_cache,
        :password,
        "#{@account.type_name}/accounts_controller"
        .camelize
        .constantize
        .new
        .profile_params
      ).tap do |tapped|
        tapped[:skip_existing_password] = true
      end
    end
  end
end
