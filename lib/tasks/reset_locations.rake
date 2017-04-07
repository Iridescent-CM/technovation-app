namespace :utils do
  desc "Reset all Account / Team locations to Mexico (doesn't run on production)"
  task reset_locations: :environment do
    if Rails.env.production?
      raise StandardError, "Unsupported task on production"
    end

    RegionalPitchEvent.find_each do |r|
      r.update_attributes({
        city: %w{Guadalajara Mexico\ City Puerto\ Vallarta Cancun Tijuana}.sample,
      })

      puts "Reset RPE #{r.name} to #{r.city}"
    end

    Team.find_each do |t|
      t.update_attributes({
        latitude: nil,
        longitude: nil,
      })

      puts "Reset Team #{t.name} to nil lat/lng"
    end

    Account.find_each do |a|
      a.update_attributes({
        city: "Guadalajara",
        state_province: "Jalisco",
        country: "MX",
        latitude: nil,
        longitude: nil,
      })

      puts "Reset Account #{a.email} to #{a.city}"
    end

    puts "Account latitudes are now: #{Account.pluck(:latitude).distinct}"
    puts "Team latitudes are now: #{Team.pluck(:latitude).distinct}"
  end
end
