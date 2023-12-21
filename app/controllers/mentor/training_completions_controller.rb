module Mentor
  class TrainingCompletionsController < MentorController
    def show
      current_mentor.complete_training!
      redirect_to mentor_dashboard_path,
        success: "Thank you for completing the mentor training!"
    end
  end
end
