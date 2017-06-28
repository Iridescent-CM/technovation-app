module V3
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    add_flash_types :success
    add_flash_types :error

    force_ssl if: :ssl_configured?

    rescue_from "ActionController::ParameterMissing" do |e|
      if e.message.include?("token")
        redirect_to token_error_path
      else
        raise e
      end
    end

    rescue_from "Rack::Timeout::RequestTimeoutException" do |e|
      redirect_to timeout_error_path(back: request.fullpath)
    end

    private
    def ssl_configured?
      !Rails.env.development? && !Rails.env.test?
    end
  end
end
