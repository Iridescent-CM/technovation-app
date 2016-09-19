module Student
  class SignupsController < ApplicationController
    include SignupController

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
