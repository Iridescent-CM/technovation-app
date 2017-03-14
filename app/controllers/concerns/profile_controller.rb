module ProfileController
  extend ActiveSupport::Concern

  included do
    helper_method :account, :edit_profile_path

    before_action -> {
      @uploader = ImageUploader.new
      @uploader.success_action_redirect = send(
        "#{account.type_name}_profile_image_upload_confirmation_url"
      )
    }, only: :show
  end

  def edit
    if not account.valid? and account.account.errors.keys.include?(:geocoded)
      account.geocoded = nil
      account.city = nil
      account.state_province = nil
      account.country = nil
    end
  end

  def update
    if account.update_attributes(account_params)
      redirect_to after_update_path, success: t('controllers.accounts.update.success')
    else
      render :edit
    end
  end


  private
  def account_params
    params.require(account_param_root).permit(
      profile_params,
      account_attributes: [
        :id,
        :existing_password,
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
        :confirm_sentence,
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
    if /dashboard\z/.match(request.referer)
      :back
    else
      send("#{account.type_name}_profile_path")
    end
  end
end
