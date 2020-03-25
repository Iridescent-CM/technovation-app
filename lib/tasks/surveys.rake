def reset(scope)
  scope.update_all(
    reminded_about_survey_at: nil,
    reminded_about_survey_count: 0,
    pre_survey_completed_at: nil
  )
end

namespace :surveys do
  desc "Reset survey reminders for students"
  task reset_students: :environment do
    reset(Account.joins(:student_profile))
  end

  desc "Reset survey reminders for mentors"
  task reset_mentors: :environment do
    reset(Account.joins(:mentor_profile))
  end

  desc "Reset survey reminders for all users"
  task reset_all: :environment do
    reset(Account)
  end
end