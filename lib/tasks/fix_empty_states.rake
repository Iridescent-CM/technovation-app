desc "Reverse geocode all current accounts with an empty state"
task fix_empty_states: :environment do
  accounts = Account.current.where(state_province: nil)
    .where.not(country: nil)

  puts "Accounts with empty states: #{accounts.count}"
  puts "Reverse geocoding now..."

  accounts.find_each do |account|
    puts "===================================="

    city = account.city
    state = account.state
    country = account.country

    account.reverse_geocode

    if state != account.state
      puts "Account##{account.id} GEOCODING FIXED:"
      puts "City from: `#{city}` to `#{account.city}`"
      puts "State from: `#{state}` to `#{account.state}`"
      puts "Country from: `#{country}` to `#{account.country}`"

      account.geocoding_fixed_at = Time.current
      account.geocoding_city_was = city
      account.geocoding_state_was = state
      account.geocoding_country_was = country
      account.save
    else
      puts "*********** !!! ************"
      puts "Account##{account.id} had NO CHANGES:"
      puts "City from: `#{city}` to `#{account.city}`"
      puts "State from: `#{state}` to `#{account.state}`"
      puts "Country from: `#{country}` to `#{account.country}`"
    end
  end

  accounts = Account.current.where(state_province: nil)
    .where.not(country: nil)

  puts "===================================="
  puts "...done!"
  puts "Accounts with empty states: #{accounts.count}"
end