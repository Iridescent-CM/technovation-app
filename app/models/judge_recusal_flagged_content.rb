class JudgeRecusalFlaggedContent < ActiveRecord::Base
  belongs_to :submission_score

  enum name: {
    problem_or_project_description: 10,
    pitch_video: 20,
    technical_video: 30,
    learning_journey: 40,
    user_adoption_plan: 50,
    business_canvas: 60
  }
end
