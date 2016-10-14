class BackFillPendingActiveSignupAttempts < ActiveRecord::Migration
  def up
    (SignupAttempt.pending | SignupAttempt.active).each do |attempt|
      puts "Setting scrambled temporary password for #{attempt.email}"
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      password_digest = BCrypt::Password.create(SecureRandom.hex(17), cost: cost)
      attempt.update_columns(password_digest: password_digest,
                             status: SignupAttempt.statuses[:temporary_password])
    end
  end
end
