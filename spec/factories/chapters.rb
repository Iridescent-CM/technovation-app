FactoryBot.define do
  factory :chapter do
    sequence(:name) { |n| "FactoryBot Program #{n}" }
    sequence(:summary) { |n| "FactoryBot Summary #{n}" }
    sequence(:organization_name) { |n| "FactoryBot Organization #{n}" }
    visible_on_map { true }
    sequence(:organization_headquarters_location) { |n| "FactoryBot Location #{n}" }
    chapter_links { build_list :chapter_link, 3 }

    association :legal_contact

    after(:build) do |chapter|
      build(:chapter_program_information,
        chapter: chapter)
    end

    after(:create) do |chapter|
      create(:chapter_program_information,
        chapter: chapter)
    end

    trait :chicago do
      city { "Chicago" }
      state_province { "IL" }
      country { "US" }
    end

    trait :los_angeles do
      city { "Los Angeles" }
      state_province { "CA" }
      country { "US" }
    end

    trait :brazil do
      city { "Salvador" }
      state_province { "Bahia" }
      country { "BR" }
    end
  end
end
