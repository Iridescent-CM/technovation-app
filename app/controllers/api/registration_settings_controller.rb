module Api
  class RegistrationSettingsController < ApplicationController
    def index
      render json: {
        isStudentRegistrationOpen: SeasonToggles.student_registration_open?,
        isMentorRegistrationOpen: SeasonToggles.mentor_registration_open?,
        isJudgeRegistrationOpen: SeasonToggles.judge_registration_open?
      }
    end
  end
end
