FactoryBot.define do
  factory :certificate, aliases: [:cert] do
    account
    team

    season { Season.current.year }

    trait :past do
      season { Season.current.year - (1..10).to_a.sample }
    end

    trait :with_file do
      after(:create) do |certificate|
        certificate.update_column(:file, "certificate.pdf")
      end
    end
  end
end
