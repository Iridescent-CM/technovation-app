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

      paper_prototype {
        Rack::Test::UploadedFile.new(
          File.join(Rails.root, 'spec', 'support', 'imgs', 'natasha-avatar.jpg'),
          'image/jpg'
        )
      }

      event_flow_chart {
        Rack::Test::UploadedFile.new(
          File.join(Rails.root, 'spec', 'support', 'imgs', 'natasha-avatar.jpg'),
          'image/jpg'
        )
      }
    end
  end
end
