FactoryBot.define do
  factory :legal_contact do
    full_name { "FactoryBot Legal Contact" }
    sequence(:email_address) { |n| "legal-contact-#{n}@example.com" }

    transient do
      season_chapter_affiliation_agreement_signed { 2026 }
    end

    after(:create) do |legal_contact, evaluator|
      create(:chapter_affiliation_agreement,
        signer: legal_contact,
        season_signed: evaluator.season_chapter_affiliation_agreement_signed,
        signed_at: Time.now)
    end
  end
end
