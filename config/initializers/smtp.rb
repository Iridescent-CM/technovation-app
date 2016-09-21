unless Rails.env.development? or Rails.env.test?
  Rails.application.configure do
    config.action_mailer.delivery_method = :smtp

    config.action_mailer.smtp_settings = {
      address: ENV.fetch("MAIL_ADDRESS"),
      port: ENV.fetch("MAIL_PORT"),
      user_name: ENV.fetch("MAIL_USER"),
      password: ENV.fetch("MAIL_PASSWORD"),
      domain: 'technovationchallenge.org',
      authentication: :login,
      enable_starttls_auto: true,
      tls: true,
    }
  end
end
