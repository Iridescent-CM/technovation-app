module Admin
  class ParticipantsController < AdminController
    def index
    end

    def edit
    end

    def update
    end

    private
    def profile_params
      params.require("#{account.scope_name}_profile").permit(
        "#{account.scope_name}/profiles_controller"
        .camelize
        .constantize
        .new
        .profile_params,
        account_attributes: [
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
        ],
      ).tap do |tapped|
        tapped.fetch(:account_attributes) { {} }[:skip_existing_password] = true
      end
    end
  end
end
