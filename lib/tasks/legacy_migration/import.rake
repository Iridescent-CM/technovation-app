namespace :legacy_migration do
  desc "Import from the legacy database"
  task import: :environment do
    ActiveRecord::Base.transaction do
      require './lib/legacy/helpers/profile_attributes'
      require './lib/legacy/models/user'

      Legacy::User.where(is_registered: true).each do |user|
        account = "#{user.role}_account".camelize.constantize.new(
          email: user.email,
          password_digest: user.encrypted_password,
          first_name: user.first_name,
          last_name: user.last_name,
          date_of_birth: user.birthday,
          city: user.home_city,
          state_province: user.migrated_home_state,
          country: user.home_country,
          "#{user.role}_profile_attributes" => ProfileAttributes.(user),
        )
        GenerateToken.(account, :auth_token)
        account.save(validate: false)
        puts "Migrated account for: #{account.email}"
      end

      puts "Migrated #{Account.count} accounts"

      Legacy::Team.where(year: 2016).each do |legacy_team|
        team = Team.create!(name: legacy_team.name,
                            description: legacy_team.migrated_description,
                            division: legacy_team.migrated_division,
                            member_ids: legacy_team.migrated_member_ids)
        puts "Migrated team for: #{team.name}"
      end

      puts "Migrated #{Team.count} team"
    end
  end
end
