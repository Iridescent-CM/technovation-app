class ConvertAssignedJudgesToPolymorphism < ActiveRecord::Migration[5.1]
  def up
    judges = JudgeAssignment.where.not(judge_profile_id: nil)
    invites = JudgeAssignment.where(judge_profile_id: nil).where.not(user_invitation_id: nil)

    add_column :judge_assignments, :assigned_judge_type, :string
    add_column :judge_assignments, :assigned_judge_id, :integer

    judges.find_each do |j|
      j.update_columns({
        assigned_judge_type: "JudgeProfile",
        assigned_judge_id: j.judge_profile_id
      })
    end

    invites.find_each do |i|
      i.update_columns({
        assigned_judge_type: "UserInvitation",
        assigned_judge_id: i.user_invitation_id
      })
    end

    remove_column :judge_assignments, :judge_profile_id
    remove_column :judge_assignments, :user_invitation_id
  end

  def down
    judges = JudgeAssignment.where(assigned_judge_type: "JudgeProfile")
    invites = JudgeAssignment.where(assigned_judge_type: "UserInvitation")

    add_column :judge_assignments, :judge_profile_id, :integer
    add_column :judge_assignments, :user_invitation_id, :integer

    judges.find_each do |j|
      j.update_column(:judge_profile_id, j.assigned_judge_id)
    end

    invites.find_each do |i|
      i.update_column(:user_invitation_id, i.assigned_judge_id)
    end

    remove_column :judge_assignments, :assigned_judge_id
    remove_column :judge_assignments, :assigned_judge_type
  end
end
