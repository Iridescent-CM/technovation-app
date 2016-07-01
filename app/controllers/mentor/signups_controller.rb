module Mentor
  class SignupsController < ApplicationController
    include Signup
    include GuidanceProfileSignup

    private
    def model_name
      "mentor"
    end
  end
end
