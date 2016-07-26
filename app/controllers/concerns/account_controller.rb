module AccountController
  extend ActiveSupport::Concern

  included do
    helper_method :account, :edit_account_path
  end

  def edit
    account
  end

  def update
    if account.update_attributes(account_params)
      redirect_to after_update_redirect_path,
                  success: t('controllers.accounts.update.success')
    else
      render :edit
    end
  end


  private
  def account_params
    params.require(account_param_root).permit(
      :email,
      :existing_password,
      :password,
      :password_confirmation,
      :date_of_birth,
      :first_name,
      :last_name,
      :city,
      :state_province,
      :country,
      :profile_image,
      profile_params,
    )
  end

  def account_param_root
    :account
  end

  def profile_params
    { }
  end
end
