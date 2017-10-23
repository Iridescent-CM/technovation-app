module Admin
  class ParticipantsController < AdminController
    def index
      @accounts_grid = AccountsGrid.new(params[:accounts_grid].merge(admin: true)) do |scope|
        scope.page(params[:page])
      end
    end

    def show
      @account = Account.find(params.fetch(:id))
    end

    def edit
      @account = Account.find(params.fetch(:id))
    end

    def update
      @account = Account.find(params.fetch(:id))
      profile = @account.send("#{@account.scope_name}_profile")

      profile_params = account_params.delete(
        "#{@account.scope_name}_profile_attributes"
      ) || {}

      profile_params[:account_attributes] = {
        id: params.fetch(:id),
      }.merge(account_params)

      if ProfileUpdating.execute(profile, @account.scope_name, profile_params)
        redirect_to admin_participant_path(@account),
          success: "You updated #{@account.full_name}'s account"
      else
        render :edit
      end
    end

    private
    def account_params
      params.require(:account).permit(
        :id,
        :email,
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
        "#{@account.scope_name}_profile_attributes" =>
          "#{@account.scope_name}/profiles_controller"
            .camelize
            .constantize
            .new
            .profile_params,
      ).tap do |tapped|
        tapped[:skip_existing_password] = true
      end
    end
  end
end
