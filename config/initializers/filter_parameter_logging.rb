# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :password_confirmation,
                                               :ssn, :drivers_license_number,
                                               :email, :last_name, :parent_guardian_name,
                                               :parent_guardian_email, :date_of_birth]
