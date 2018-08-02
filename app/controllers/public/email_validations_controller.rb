require 'net/http'
require 'json'

module Public
  class EmailValidationsController < PublicController
    def new
      resp = get_email_validation_response(params.fetch(:address))
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
          mailbox_verification: enable_mailbox_verification?(address),
        },
        basic_auth: {
          username: 'api',
          password: ENV.fetch("MAILGUN_PRIVATE_KEY"),
        }
      )
    end

    def enable_mailbox_verification?(address)
      !(address.match(/^.+\+.+@/) && !address.match(/@gmail.com$/))
    end
  end
end