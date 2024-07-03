FactoryBot.define do
  factory :legal_contact do
    full_name { "FactoryBot Legal Contact" }
    sequence(:email_address) { |n| "legal-contact-#{n}@example.com" }

    transient do
      season_legal_document_signed { 2026 }
    end

    after(:create) do |legal_contact, evaluator|
      create(:legal_document,
        signer: legal_contact,
        season_signed: evaluator.season_legal_document_signed,
        signed_at: Time.now)
    end
  end
end
