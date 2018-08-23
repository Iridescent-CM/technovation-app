module Student
  class BasicProfilesController < StudentController
    def update
      if ProfileUpdating.execute(current_student, modified_profile_params)
        render json: AccountSerializer.new(current_account).serialized_json
      else
        render json: { errors: current_student.errors }, status: :unprocessessable_entity
      end
    end

    private
    def modified_profile_params
      hashed_params = basic_profile_params.to_h

      {
        school_name: hashed_params.fetch(:school_company_name) { current_student.school_name },

        account_attributes: {
          id: current_account.id,

          first_name: hashed_params.fetch(:first_name) { account.first_name },
          last_name: hashed_params.fetch(:last_name) { account.last_name },

          referred_by_other: hashed_params.fetch(:referred_by_other) { account.referred_by_other },
          referred_by: hashed_params.fetch(:referred_by) { account.referred_by},
        },
      }
    end

    def basic_profile_params
      params.require(:basic_profile).permit(
        :first_name,
        :last_name,
        :school_company_name,
        :referred_by,
        :referred_by_other,
      )
    end
  end
end