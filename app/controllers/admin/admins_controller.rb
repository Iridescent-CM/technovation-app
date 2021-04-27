module Admin
  class AdminsController < AdminController
    before_action :get_admins, only: [:index, :destroy]

    TECHNOVATION_ESTABLISHED_DATE = Date.new(2009, 1, 1)

    def new
      @admin = Account.new
    end

    def create
      @admin = Account.new(admin_account_params)
      @admin.build_admin_profile

      if @admin.save
        AdminMailer.invite_new_admin(@admin).deliver_later

        redirect_to admin_admins_path,
          success: "An invite was sent to #{@admin.email}"
      else
        render :new
      end
    end

    def destroy
      admin = @admins.find(params.fetch(:id))
      admin.destroy!
      redirect_to admin_admins_path, success: "You deleted #{admin.name}"
    end

    private
    def admin_account_params
      params.require(:account)
        .permit(:first_name, :last_name, :email)
        .tap do |permitted_params|
          permitted_params[:inviting_new_admin] = true
          permitted_params[:date_of_birth] = TECHNOVATION_ESTABLISHED_DATE
          permitted_params[:gender] = "Prefer not to say"
        end
    end

    def get_admins
      @admins = Account.joins(:admin_profile)
    end
  end
end