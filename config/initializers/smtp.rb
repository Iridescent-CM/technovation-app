unless ENV["USE_DOTENV"].present?
  Rails.application.configure do
    config.action_mailer.delivery_method = :smtp

    config.action_mailer.smtp_settings = {
      address: ENV.fetch("MAIL_ADDRESS"),
      port: ENV.fetch("MAIL_PORT"),
      user_name: ENV.fetch("MAIL_USER"),
      password: ENV.fetch("MAIL_PASSWORD"),
      authentication: :plain,
      enable_starttls_auto: true,
    }
  end
end
