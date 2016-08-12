namespace :legacy_migration do
  desc "Import from the legacy database"
  task import: :environment do
    ActiveRecord::Base.transaction do
      require './lib/legacy/helpers/profile_attributes'
      require './lib/legacy/models/user'

      Legacy::User.find_each do |user|
        user.role = "mentor" if user.role == "coach"

        account = "#{user.role}_account".camelize.constantize.new(
          email: user.email,
          password_digest: user.encrypted_password,
          first_name: user.first_name,
          last_name: user.last_name,
          date_of_birth: user.birthday,
          city: user.home_city,
          state_province: user.migrated_home_state,
          country: user.home_country,
          created_at: user.created_at,
          "#{user.role}_profile_attributes" => ProfileAttributes.(user),
        )

        GenerateToken.(account, :auth_token)

        account.save(validate: false)
        RegisterToSeasonJob.perform_later(account)

        puts "Migrated #{account.type} for: #{account.email}"
      end

      Legacy::Team.where(year: [2015, 2016]).each do |legacy_team|
        team = Team.new(name: legacy_team.name,
                        description: legacy_team.migrated_description,
                        division: legacy_team.migrated_division,
                        student_ids: legacy_team.migrated_student_ids,
                        mentor_ids: legacy_team.migrated_mentor_ids,
                        created_at: legacy_team.created_at)

        team.save(validate: false)
        RegisterToSeasonJob.perform_later(team)
        puts "Migrated team for: #{team.name}"
      end

      puts "Migrated #{Account.count} accounts"
      puts "Migrated #{Team.count} teams"
    end
  end
end
