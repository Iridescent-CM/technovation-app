require 'net/http'
require 'json'

module Public
  class EmailValidationsController < PublicController
    def new
      address = params.fetch(:address)

      account = Account.find_by(
        "lower(trim(unaccent(email))) = ?",
        address.strip.downcase
      )

      if !!account
        response = {
          address: address,
          is_valid: true,
          mailbox_verification: "true",
          is_taken: true,
        }
      else
        response = HTTParty.get(
          'https://api.mailgun.net/v3/address/private/validate',
          query: {
            address: address,
            mailbox_verification: true,
          },
          basic_auth: {
            username: 'api',
            password: ENV.fetch("MAILGUN_PRIVATE_KEY"),
          }
        )
      end

      attempt = SignupAttempt.find_by(
        "lower(trim(unaccent(email))) = ?",
        address.strip.downcase
      )

      if !attempt && response[:is_valid] && !response[:is_taken]
        attempt = SignupAttempt.create!({
          email: address,
          status: :wizard,
        })
      end

      if !!attempt
        set_cookie(CookieNames::SIGNUP_TOKEN, attempt.wizard_token)
      end

      mailgun_response = MailgunResponse.new(response)
      render json: MailgunResponseSerializer.new(mailgun_response).serialized_json
    end
  end
end