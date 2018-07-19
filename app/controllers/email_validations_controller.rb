require 'net/http'
require 'json'

class EmailValidationsController < ApplicationController
  def new
    address = params.fetch(:address)

    if Account.exists?(email: address.strip.downcase)
      response = {
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

    render json: response
  end
end