module BasicProfileController
  extend ActiveSupport::Concern

  included do
    instance_variable_set(:@profile_helper_method, :current_profile)
    instance_variable_set(:@params_safelist_arr, [])
    instance_variable_set(:@params_safelist_hsh, {})
  end

  module ClassMethods
    def with_profile(helper_method)
      instance_variable_set(:@profile_helper_method, helper_method)
    end

    def with_params(*params_safelist_arr, **params_safelist_hsh)
      instance_variable_set(:@params_safelist_arr, params_safelist_arr)
      instance_variable_set(:@params_safelist_hsh, params_safelist_hsh)
    end
  end

  def update
    if ProfileUpdating.execute(profile, profile_params)
      render json: AccountSerializer.new(current_account).serialized_json
    else
      render json: {errors: profile.errors}, status: :unprocessessable_entity
    end
  end

  private

  def profile_params
    params_safelist.to_update_hash(
      given: hashed_params,
      fallback: profile
    ).merge(account_attributes)
  end

  def account_attributes
    {
      account_attributes: {
        id: current_account.id,

        first_name: hashed_params.fetch(:first_name) { current_account.first_name },
        last_name: hashed_params.fetch(:last_name) { current_account.last_name },

        referred_by_other: hashed_params.fetch(:referred_by_other) { current_account.referred_by_other },
        referred_by: hashed_params.fetch(:referred_by) { current_account.referred_by },

        gender: hashed_params.fetch(:gender_identity) { current_account.gender }
      }
    }
  end

  def hashed_params
    basic_profile_params.to_h
  end

  def basic_profile_params
    params.require(:basic_profile).permit(
      :first_name,
      :last_name,
      :referred_by,
      :referred_by_other,
      :gender_identity,
      *params_safelist.to_permitted_params_list
    )
  end

  def params_safelist
    arr = self.class.instance_variable_get(:@params_safelist_arr)
    hsh = self.class.instance_variable_get(:@params_safelist_hsh)
    ParamKeys.new(arr, hsh)
  end

  def profile
    send(self.class.instance_variable_get(:@profile_helper_method))
  end
end
