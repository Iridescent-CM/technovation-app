class AllowNullMentorProfileIdOnMentorProfileExpertises < ActiveRecord::Migration[5.1]
  def change
    change_column_null :mentor_profile_expertises, :mentor_profile_id, true
  end
end
