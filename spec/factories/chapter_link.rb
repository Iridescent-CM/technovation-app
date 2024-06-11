FactoryBot.define do
  factory :chapter_link, class: "RegionalLink" do
    name { "website" }
    sequence(:value) { |n| "FactoryBot.website/#{n}" }
    chapter_ambassador_profile_id { nil }
  end
end
