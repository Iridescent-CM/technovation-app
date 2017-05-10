FactoryGirl.define do
  factory :legacy_admin, class: AdminProfile do
    account { FactoryGirl.create(:legacy_account) }
  end
end
