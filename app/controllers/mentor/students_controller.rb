module Mentor
  class StudentsController < MentorController
    layout "mentor_rebrand"
    def show
      @student = StudentProfile.find(params.fetch(:id))
    end
  end
end
