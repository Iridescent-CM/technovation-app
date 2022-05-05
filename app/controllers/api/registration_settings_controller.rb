module Api
  class RegistrationSettingsController < ApplicationController
    def index
      render json: {
        isRegistrationOpen: SeasonToggles.registration_open?,
        isStudentRegistrationOpen: SeasonToggles.student_registration_open?,
        isMentorRegistrationOpen: SeasonToggles.mentor_registration_open?
      }
    end
  end
end
