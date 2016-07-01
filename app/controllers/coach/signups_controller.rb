module Coach
  class SignupsController < ApplicationController
    include Signup
    include GuidanceProfileSignup

    private
    def model_name
      "coach"
    end
  end
end
