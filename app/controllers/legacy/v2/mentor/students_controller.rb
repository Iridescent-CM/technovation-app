module Legacy
  module V2
    module Mentor
      class StudentsController < MentorController
        def show
          @student = StudentProfile.find(params.fetch(:id))
        end
      end
    end
  end
end
