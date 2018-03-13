class AddUserInvitationsToJudgeAssignments < ActiveRecord::Migration[5.1]
  def change
    add_reference :judge_assignments, :user_invitation, foreign_key: true
  end
end
