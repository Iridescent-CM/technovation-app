module Admin
  class ProfilesController < AdminController
    helper_method :account

    def index
      params[:page] = 1 if params[:page].blank?
      params[:per_page] = 15 if params[:per_page].blank?

      @accounts = SearchAccounts.(params)
        .page(params[:page].to_i)
        .per_page(params[:per_page].to_i)

      if @accounts.empty?
        @accounts = @accounts.page(1)
      end
    end

    def show
      account
    end

    def edit
      account
      @expertises ||= Expertise.all
    end

    def update
      type = params.keys.detect { |k| k =~ /_profile/ }

      @profile = type.camelize.constantize.find(params[:id])
      @account = @profile.account

      if @profile.update_attributes(profile_params)
        if params[:regional_ambassador_profile]
          redirect_to admin_regional_ambassador_path(@account),
            success: "Account information saved"
        else
          redirect_to admin_profile_path(@account),
            success: "Account information saved"
        end
      else
        @expertises ||= Expertise.all
        render :edit
      end
    end

    private
    def profile_params
      params.require("#{account.type_name}_profile").permit(
        "#{account.type_name}/profiles_controller"
        .camelize
        .constantize
        .new
        .profile_params,
        account_attributes: [
          :id,
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
          :location_confirmed,
        ],
      ).tap do |tapped|
        tapped[:skip_existing_password] = true
      end
    end

    def account
      @account ||= Account.find(params[:id])
      @profile ||= @account.send("#{@account.type_name}_profile")
      @account
    end
  end
end
