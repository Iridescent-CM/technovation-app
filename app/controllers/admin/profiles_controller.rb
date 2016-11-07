module Admin
  class ProfilesController < AdminController
    helper_method :account

    def index
      accounts = SearchAccounts.(params)
      @accounts = accounts.paginate(per_page: params[:per_page], page: params[:page])
    end

    def show
      account
    end

    def edit
      account
      @expertises ||= Expertise.all
    end

    def update
      account

      if @account.update_attributes(account_params)
        redirect_to admin_profile_path(@account),
          success: "Account information saved"
      else
        @expertises ||= Expertise.all
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

    def account
      @account ||= Account.find(params[:id])
    end
  end
end
