FactoryGirl.define do
  factory :technical_checklist do
    
    team_submission nil

    trait :completed do
      # does not create submission, which #completed? checks for screenshots
      used_strings true
      used_strings_explanation "yep"
      used_numbers true
      used_numbers_explanation "yep"
      used_variables true
      used_variables_explanation "yep"
      used_lists true
      used_lists_explanation "yep"
      used_local_db true
      used_local_db_explanation "yep"
      used_camera true
      used_camera_explanation "yep"

      after(:create) do |o|
        o.update_column(:paper_prototype, "prototype.png")
        o.update_column(:event_flow_chart, "chart.png")
      end
    end

  end
end
