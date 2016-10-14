module Student
  class SignupsController < ApplicationController
    include SignupController

    before_action -> {
      attempt = (SignupAttempt.pending | SignupAttempt.invited).detect do |a|
        a.activation_token == params[:token]
      end

      if !!attempt and attempt.pending?
        attempt.active!
      elsif !!attempt and attempt.invited?
        attempt.regenerate_signup_token
      end

      if !!attempt
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
