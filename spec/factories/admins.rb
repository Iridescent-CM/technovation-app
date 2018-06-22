FactoryBot.define do
  factory :admin_profile, aliases: [:admin] do
    account
    admin_status :full_admin
  end
end