module SignupHelper
  def set_signup_token(email)
    token = FactoryGirl.create(:signup_attempt, email: email).activation_token
    visit new_signup_attempt_confirmation_path(token: token)
  end

  def set_signup_and_permission_token(email)
    attempt = FactoryGirl.create(:signup_attempt, email: email)
    visit new_signup_attempt_confirmation_path(token: attempt.activation_token)
    visit signup_path(admin_permission_token: attempt.admin_permission_token)
  end
end
