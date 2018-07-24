module Public
  class WizardInProgressController < PublicController
    def show
      attempt = SignupAttempt.find_by!(wizard_token: params.fetch(:id))
      render json: SignupAttemptSerializer.new(attempt).serialized_json
    end
  end
end