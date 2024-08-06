FactoryBot.define do
  factory :document, aliases: [:chapter_affiliation_agreement, :legal_agreement] do
    full_name { "FactoryBot Document Signer" }
    sequence(:email_address) { |n| "document-signer-#{n}@example.com" }
    active { true }
    sequence(:docusign_envelope_id) { |n| "envelope-id-#{n}" }

    trait :signed do
      signed_at { Time.now }
    end
  end
end
