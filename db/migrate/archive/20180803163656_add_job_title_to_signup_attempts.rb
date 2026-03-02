class AddJobTitleToSignupAttempts < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_attempts, :job_title, :string
  end
end
