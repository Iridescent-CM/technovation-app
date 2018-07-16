class EnforceUniqueAccountIdsOnProfiles < ActiveRecord::Migration[5.1]
  def change
    remove_index :student_profiles, :account_id
    remove_index :mentor_profiles, :account_id
    remove_index :judge_profiles, :account_id
    remove_index :regional_ambassador_profiles, :account_id
    remove_index :admin_profiles, :account_id

    add_index :student_profiles, :account_id, unique: true,
      name: :uniq_students_accounts

    add_index :mentor_profiles, :account_id, unique: true,
      name: :uniq_mentors_accounts

    add_index :judge_profiles, :account_id, where: "deleted_at IS NULL",
      unique: true,
      name: :uniq_judges_accounts

    add_index :regional_ambassador_profiles, :account_id, unique: true,
      name: :uniq_ambassadors_accounts

    add_index :admin_profiles, :account_id, unique: true,
      name: :uniq_admins_accounts
  end
end
