FactoryBot.define do
  factory :admin_profile, aliases: [:admin] do
    account
    admin_status { :full_admin }

    trait :inviting do
      admin_status { :temporary_password }
      skip_existing_password { true }
      password { SecureRandom.hex(10) }
    end

    trait :super_admin do
      super_admin { true }
    end

    factory :super_admin do
      super_admin { true }
    end
  end
end
