class AddUserInvitationsToMentorProfiles < ActiveRecord::Migration[5.1]
  def change
    add_reference :mentor_profiles, :user_invitation, foreign_key: true
    change_column_null :mentor_profiles, :account_id, true
  end
end
