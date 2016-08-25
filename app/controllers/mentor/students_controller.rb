module Mentor
  class StudentsController < MentorController
    def show
      @student = StudentAccount.find(params.fetch(:id))
    end
  end
end
