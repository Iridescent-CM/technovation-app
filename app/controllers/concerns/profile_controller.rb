module ProfileController
  extend ActiveSupport::Concern

  included do
    helper_method :profile, :edit_profile_path

    before_action -> {
      @uploader = ImageUploader.new
      @uploader.success_action_redirect = send(
        "#{profile.class.name.underscore}_image_upload_confirmation_url"
      )
    }, only: :show
  end

  def update
    if ProfileUpdating.execute(profile, permitted_params)
      respond_to do |format|
        format.json {
          render json: {
            flash: {
              success: t("controllers.accounts.update.success"),
            },
          },
          status: 200
        }

        format.html {
          redirect_to after_update_path,
            success: t('controllers.accounts.update.success')
        }
      end
    elsif profile.errors["account.password"].any? or
      profile.errors["account.existing_password"].any?
      if profile.account.email_changed?
        render 'email_addresses/edit'
      else
        render "passwords/edit"
      end
    elsif profile.errors["account.city"].any? or
            profile.errors["account.state_province"].any? or
              profile.errors["account.country"].any?
      render "location_details/show"
    else
      render :edit
    end
  end

  private
  def permitted_params
    params.require(profile_param_root).permit(
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
        :icon_path,
      ],
    )
  end

  def profile_param_root
    :account
  end

  def profile_params
    { }
  end

  def after_update_path
    if not params[:return_to].blank?
      params[:return_to]
    else
      [profile.class.name.underscore.sub("_profile", ""), :profile]
    end
  end
end
