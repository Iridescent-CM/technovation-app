module Student
  class SignupsController < ApplicationController
    include SignupController

    before_action -> {
      if attempt = SignupAttempt.pending.find_by(activation_token: params[:token])
        attempt.active!
        cookies[:signup_token] = attempt.signup_token
      end
    }, only: :new

    private
    def model_name
      "student"
    end

    def profile_params
      %i{
          school_name
        }
    end
  end
end
