require 'net/http'
require 'json'

module Public
  class EmailValidationsController < PublicController
    def new
      address = params.fetch(:address)
      resp = get_email_validation_response(address)

      handle_signup_attempt(address, resp)

      render json: MailgunResponseSerializer.new(resp).serialized_json
    end

    private
    def get_email_validation_response(address)
      account = Account.find_by(
        "lower(trim(unaccent(email))) = ?",
        address.strip.downcase
      )

      if !!account
        MailgunResponse.new(email_taken_response)
      else
        MailgunResponse.new(get_mailgun_response(address))
      end
    end

    def handle_signup_attempt(address, resp)
      attempt = SignupAttempt.find_by(
        "lower(trim(unaccent(email))) = ?",
        address.strip.downcase
      )

      if !attempt && resp.is_valid && !resp.is_taken
        attempt = SignupAttempt.create!(
          email: address,
          status: :wizard,
        )
      end

      if !!attempt
        if attempt.wizard_token.blank?
          attempt.regenerate_wizard_token
        end

        set_cookie(CookieNames::SIGNUP_TOKEN, attempt.wizard_token)
      end
    end

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