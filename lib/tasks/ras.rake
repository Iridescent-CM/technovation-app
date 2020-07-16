namespace :ras do
  desc "List all current season chapter ambassador assignments"
  task ra_data_dump: :environment do
    puts "Exporting data..."

    filename = "./#{Season.current.year}-ra-dump.csv"

    CSV.open(filename, 'wb') do |csv|
      csv << %w{
        User\ Email
        User\ Country
        User\ State/province
        User\ City
        RA\ Email
        RA\ Country
        RA\ State/province
        RA\ City
      }

      [
        Account.current.joins(:student_profile),
        Account.current.joins(:mentor_profile)
      ].each do |query|
        query.find_each do |account|
          unless account.geocoded?
            puts "#{account.email} not geocoded"
          end
          row = []
          row << account.email
          row << account.country
          row << account.state_province
          row << account.city
          if account.regional_ambassador.present?
            unless account.regional_ambassador.geocoded?
              puts "RA #{account.regional_ambassador.email} not geocoded"
            end
            row << account.regional_ambassador.account.email
            row << account.regional_ambassador.account.country
            row << account.regional_ambassador.account.state_province
            row << account.regional_ambassador.account.city
          end

          csv << row
        end
      end
    end

    puts "Data exported to #{filename}"
  end
end
