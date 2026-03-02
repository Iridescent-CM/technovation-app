class AddSignupAttemptIdToMentorProfileExpertises < ActiveRecord::Migration[5.1]
  def change
    add_reference :mentor_profile_expertises, :signup_attempt, foreign_key: true
  end
end
