namespace :chapter_ambassadors do
  desc "List all current season chapter ambassador assignments"
  task chapter_ambassador_data_dump: :environment do
    puts "Exporting data..."

    filename = "./#{Season.current.year}-chapter-ambassador-dump.csv"

    CSV.open(filename, "wb") do |csv|
      csv << %w[
        User\ Email
        User\ Country
        User\ State/province
        User\ City
        Chapter\ Ambassador\ Email
        Chapter\ Ambassador\ Country
        Chapter\ Ambassador\ State/province
        Chapter\ Ambassador\ City
      ]

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
          if account.chapter_ambassador.present?
            unless account.chapter_ambassador.geocoded?
              puts "Chapter ambassador #{account.chapter_ambassador.email} not geocoded"
            end
            row << account.chapter_ambassador.account.email
            row << account.chapter_ambassador.account.country
            row << account.chapter_ambassador.account.state_province
            row << account.chapter_ambassador.account.city
          end

          csv << row
        end
      end
    end

    puts "Data exported to #{filename}"
  end
end
