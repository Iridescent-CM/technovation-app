module Registration
  class ExpertisesController < RegistrationController
    def index
      expertises = Expertise.all.order(:order)

      render json: {
        attributes: expertises,
      }
    end
  end
end
