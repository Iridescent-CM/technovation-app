module Registration
  class ExpertisesController < RegistrationController
    def index
      expertises = Expertise.all

      render json: {
        attributes: expertises,
      }
    end
  end
end