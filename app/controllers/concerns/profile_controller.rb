module ProfileController
  extend ActiveSupport::Concern

  included do
    helper_method :profile, :edit_profile_path
  end

  def update
    if !!params[:setting_location] &&
         permitted_params[:account_attributes][:country].blank? &&
           permitted_params[:account_attributes][:latitude].blank?
      profile.account.errors.add(:country, :blank)
      render "location_details/show"
    elsif ProfileUpdating.execute(profile, permitted_params)
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
          redirect_to send("#{current_scope}_profile_path"),
            success: t('controllers.accounts.update.success')
        }
      end
    elsif profile.errors["parent_guardian_email"].any?
      render "student/parental_consent_notices/new"
    elsif profile.errors["account.password"].any? or
      profile.errors["account.existing_password"].any?
      if profile.account.email_changed?
        render 'email_addresses/edit'
      else
        render "passwords/edit"
      end
    elsif profile.errors["account.email"].any?
      render 'email_addresses/edit'
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
    ).tap do |tapped|
      if tapped[:account_attributes]
        tapped[:account_attributes][:id] = current_account.id
      end
    end
  end

  def profile_param_root
    :account
  end

  def profile_params
    { }
  end

  def after_update_path
    if params[:return_to].blank?
      [profile.class.name.underscore.sub("_profile", ""), :profile]
    else
      params[:return_to]
    end
  end
end
