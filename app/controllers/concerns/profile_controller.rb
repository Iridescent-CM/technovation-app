module ProfileController
  extend ActiveSupport::Concern

  included do
    helper_method :account, :edit_profile_path
    # TODO: account is actually profile

    before_action -> {
      @uploader = ImageUploader.new
      @uploader.success_action_redirect = send(
        "#{account.scope_name}_profile_image_upload_confirmation_url"
      )
    }, only: :show
  end

  def edit
    if not account.valid? and
        account.account.errors.keys.include?(:geocoded)
      account.geocoded = nil
      account.city = nil
      account.state_province = nil
      account.country = nil
    end
  end

  def update
    if ProfileUpdating.execute(account, account_params)
      redirect_to after_update_path,
        success: t('controllers.accounts.update.success')
    elsif account.errors[:password] || account.errors[:existing_password]
      if account.email_changed?
        render 'email_addresses/edit'
      else
        render "passwords/edit"
      end
    else
      render :edit
    end
  end

  private
  def account_params
    # TODO: account_params is actually profile_params
    params.require(account_param_root).permit(
      profile_params,
      account_attributes: [
        :id,
        :existing_password,
        :email,
        :password,
        :date_of_birth,
        :first_name,
        :last_name,
        :gender,
        :city,
        :state_province,
        :country,
        :latitude,
        :longitude,
      ],
    )
  end

  def account_param_root
    :account
  end

  def profile_params
    { }
  end

  def after_update_path
    if not params[:return_to].blank?
      params[:return_to]
    else
      [account.scope_name, :profile]
    end
  end
end
