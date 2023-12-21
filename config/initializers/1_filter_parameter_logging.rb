# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password,
  :password_confirmation,
  :ssn,
  :drivers_license_number,
  :email,
  :last_name,
  :parent_guardian_name,
  :parent_guardian_email,
  :date_of_birth,
  :auth_token,
  :token,
  :admin_permission_token,
  :session_token,
  :mailer_token,
  :consent_token,
  :password_reset_token,
  :download_token,
  :review_token,
  :activation_token,
  :signup_token,
  :pending_token,
  :password_digest,
  :invite_token,
  :confirmation_token,
  :address,
  :ip_address,
  :coordinates,
  :wizard_token
]
