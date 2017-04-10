namespace :utils do
  desc "Reset all Account / Team locations to Mexico (doesn't run on production)"
  task reset_locations: :environment do
    return if Rails.env.production?

    Team.find_each do |t|
      t.update_attributes({
        latitude: nil,
        longitude: nil,
      })
    end

    Account.find_each do |a|
      a.update_attributes({
        city: "Guadalajara",
        state_province: "Jalisco",
        country: "MX",
        latitude: nil,
        longitude: nil,
      })
    end

    puts "Account latitudes are now: #{Account.pluck(:latitude).uniq}"
    puts "Team latitudes are now: #{Team.pluck(:latitude).uniq}"
  end
end
