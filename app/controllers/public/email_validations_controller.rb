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

      response = if !!account
                   MailgunResponse.new(email_taken_response)
                 else
                   MailgunResponse.new(get_mailgun_response(address))
                 end

      attempt = SignupAttempt.find_by(
        "lower(trim(unaccent(email))) = ?",
        address.strip.downcase
      )

      if !attempt && response.is_valid && !response.is_taken
        attempt = SignupAttempt.create!(
          email: address,
          status: :wizard,
        )
      end

      if !!attempt
        set_cookie(CookieNames::SIGNUP_TOKEN, attempt.wizard_token)
      end

      render json: MailgunResponseSerializer.new(response).serialized_json
    end

    private
    def email_taken_response
      {
        is_valid: true,
        mailbox_verification: "true",
        is_taken: true,
      }
    end

    def get_mailgun_response(address)
      HTTParty.get(
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
  end
end