namespace :ras do
  desc "List all current season regional ambassador assignments"
  task ra_data_dump: :environment do
    puts "Exporting data..."

    filename = "./#{Season.current.year}-ra-dump.csv"

    CSV.open(filename, 'wb') do |csv|
      csv << %w{
        Id
        Country
        State/province
        City
        RA
      }

      Account.current.joins(:student_profile).find_each do |account|
        row = []
        row << account.id
        row << account.country
        row << account.state
        row << account.city
        row << account.regional_ambassador.id

        csv << row
      end
    end

    puts "Data exported to #{filename}"
  end
end
