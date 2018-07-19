require 'net/http'
require 'json'

class EmailValidationsController < ApplicationController
  def new
    response = HTTParty.get(
      'https://api.mailgun.net/v3/address/private/validate',
      query: { address: params.fetch(:address), },
      basic_auth: {
        username: 'api',
        password: ENV.fetch("MAILGUN_PRIVATE_KEY"),
      }
    )

    render json: response
  end
end