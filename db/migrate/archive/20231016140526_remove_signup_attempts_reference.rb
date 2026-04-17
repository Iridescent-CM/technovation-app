class RemoveSignupAttemptsReference < ActiveRecord::Migration[6.1]
  def change
    remove_reference :mentor_profile_expertises, :signup_attempt
  end
end
