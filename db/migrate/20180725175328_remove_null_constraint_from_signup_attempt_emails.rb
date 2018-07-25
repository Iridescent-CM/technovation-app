class RemoveNullConstraintFromSignupAttemptEmails < ActiveRecord::Migration[5.1]
  def change
    change_column_null :signup_attempts, :email, null: false
  end
end
