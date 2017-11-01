module Admin
  class ParticipantsController < AdminController
    include DatagridUser

    def index
      respond_to do |f|
        f.html do
          @accounts_grid = AccountsGrid.new(grid_params) do |scope|
            scope.page(params[:page])
          end
        end

        f.csv do
          @accounts_grid = AccountsGrid.new(grid_params)

          send_data @accounts_grid.to_csv,
            type: "text/csv",
            disposition: 'inline',
            filename: "technovation-participants-#{Time.current}.csv"
        end
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
    def grid_params
      grid = (params[:accounts_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:accounts_grid][:country]),
        state_province: Array(params[:accounts_grid][:state_province]),
        season: params[:accounts_grid][:season] || Season.current.year,
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end

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
        "#{@account.scope_name.sub(/^\w+_regional/, "regional")}_profile_attributes" =>
          "#{@account.scope_name.sub(/^\w+_regional/, "regional")}/profiles_controller"
            .camelize
            .constantize
            .new
            .profile_params,
      ).tap do |tapped|
        tapped[:skip_existing_password] = true
        tapped[:admin_making_changes] = true
      end
    end

    def param_root
      :accounts_grid
    end
  end
end
