FactoryGirl.define do
  factory :team_submission, aliases: [:submission] do
    team

    integrity_affirmed true
  end
end

