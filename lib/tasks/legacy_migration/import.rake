namespace :legacy_migration do
  desc "Import from the legacy database"
  task import: :environment do
    ActiveRecord::Base.transaction do
      require './lib/legacy/helpers/profile_attributes'
      require './lib/legacy/models/user'

      Legacy::User.where(is_registered: true).order('created_at DESC').each do |user|
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
          "#{user.role}_profile_attributes" => ProfileAttributes.(user),
        )

        GenerateToken.(account, :auth_token)

        begin
          account.save!
        rescue ActiveRecord::RecordInvalid => e
          if e.message == "Validation failed: Password can't be blank, Password confirmation can't be blank" or
               e.message == "Validation failed: Password can't be blank, Password confirmation can't be blank, Email cannot be the same as your parent/guardian's email" or
                 e.message == "Validation failed: Email is invalid, Password can't be blank, Password confirmation can't be blank" or
            account.save(validate: false)
          else
            raise e
          end
        end

        puts "Migrated #{account.type} for: #{account.email}"
      end

      puts "Migrated #{Account.count} accounts"

      Legacy::Team.where(year: 2016).each do |legacy_team|
        team = Team.create!(name: legacy_team.name,
                            description: legacy_team.migrated_description,
                            division: legacy_team.migrated_division,
                            student_ids: legacy_team.migrated_student_ids,
                            mentor_ids: legacy_team.migrated_mentor_ids)
        puts "Migrated team for: #{team.name}"
      end

      puts "Migrated #{Team.count} teams"
    end
  end
end
