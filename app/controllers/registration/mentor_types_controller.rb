module Registration
  class MentorTypesController < RegistrationController
    def index
      render json: MentorType.all.order(:order)
    end
  end
end
