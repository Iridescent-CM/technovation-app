module Registration
  class MentorTypesController < RegistrationController
    def index
      mentor_types = MENTOR_TYPE_OPTIONS.map do |mentor_type, index|
        {name: mentor_type, id: index}
      end

      render json: mentor_types
    end
  end
end
