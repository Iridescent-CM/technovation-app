module Api::Registration
  class SettingsController < ActionController::API
    def index
      registration_validator = RegistrationSettingsAggregator.new(invite_code: params[:invite_code], team_invite_code: params[:team_invite_code]).call

      render json: {
        isStudentRegistrationOpen: registration_validator.student_registration_open?,
        isParentRegistrationOpen: registration_validator.parent_registration_open?,
        isMentorRegistrationOpen: registration_validator.mentor_registration_open?,
        isJudgeRegistrationOpen: registration_validator.judge_registration_open?,
        isChapterAmbassadorRegistrationOpen: registration_validator.chapter_ambassador_registration_open?,
        invitedRegistrationProfileType: registration_validator.invited_registration_profile_type,
        successMessage: registration_validator.success_message,
        errorMessage: registration_validator.error_message
      }
    end
  end
end
