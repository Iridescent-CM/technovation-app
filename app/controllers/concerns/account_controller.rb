module AccountController
  extend ActiveSupport::Concern

  included do
    helper_method :account, :edit_account_path

    before_action -> {
      if key = params.delete(:key)
        ProcessUploadJob.perform_later(account, "profile_image", key)
        flash[:success] = t("controllers.accounts.show.image_processing")
      end

      @uploader = account.profile_image
      @uploader.success_action_redirect = send("#{account.type_name}_account_url")
    }, only: :show
  end

  def edit
    account
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
      :email,
      :existing_password,
      :password,
      :password_confirmation,
      :date_of_birth,
      :first_name,
      :last_name,
      :gender,
      :geocoded,
      :city,
      :state_province,
      :country,
      :latitude,
      :longitude,
      :profile_image,
      :profile_image_cache,
      :pre_survey_completed_at,
      profile_params,
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
      send("#{account.type_name}_account_path")
    end
  end
end
