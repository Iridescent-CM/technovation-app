FactoryGirl.define do
  factory :honor_code_agreement do
    electronic_signature "Signy McHonor"
    agreement_confirmed true
    account
  end
end
