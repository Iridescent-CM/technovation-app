namespace :legacy_migration do
  desc "Import users from the legacy database"
  task import_users: :environment do
    require './lib/legacy/models/user'

    Account.establish_connection

    Legacy::User.find_each do |user|
      account = Account.new(region: Region.last,
                            email: user.email,
                            password_digest: user.encrypted_password,
                            first_name: user.first_name,
                            last_name: user.last_name,
                            date_of_birth: user.birthday,
                            city: user.home_city,
                            country: user.home_country)
      GenerateToken.(account, :auth_token)
      account.save(validate: false)
      puts "Migrated account for: #{account.email}"
    end

    puts "Migrated #{Account.count} accounts"
  end
end
