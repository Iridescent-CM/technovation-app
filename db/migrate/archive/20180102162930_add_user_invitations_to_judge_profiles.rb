class AddUserInvitationsToJudgeProfiles < ActiveRecord::Migration[5.1]
  def change
    add_reference :judge_profiles, :user_invitation, foreign_key: true
    change_column_null :judge_profiles, :account_id, true
  end
end
