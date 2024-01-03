desc "Reverse geocode all current accounts with an empty state"
task fix_empty_states: :environment do
  accounts = Account.current.where(state_province: nil)
    .where.not(country: nil)

  puts "Accounts with empty states: #{accounts.count}"
  puts "Reverse geocoding now..."

  accounts.find_each do |account|
    puts "===================================="
    puts "Account##{account.id}"
    puts "City: #{account.city}"
    puts "Country: #{account.country}"

    city = account.city
    state = account.state
    country_code = FriendlyCountry.new(account).as_short_code

    account.reverse_geocode

    new_state = account.state
    new_country_code = FriendlyCountry.new(account).as_short_code

    if !new_state.blank?
      if new_country_code == country_code
        puts "----------- ??? -------------"
        puts "STATE CHANGED"
        puts "State became: `#{account.state}`"

        account.city = city
        account.geocoding_fixed_at = Time.current

        puts "City is: #{account.city}"
        puts "Country is: #{account.country}"
        account.save
      else
        puts "*********** !!! ************"
        puts "CHANGES TOO DRASTIC"
        puts "Country would have gone from #{country_code} to #{new_country_code}"
      end
    else
      puts "*********** !!! ************"
      puts "STATE WAS STILL BLANK"
    end
  end

  accounts = Account.current.where(state_province: nil)
    .where.not(country: nil)

  puts "===================================="
  puts "...done!"
  puts "Accounts with empty states: #{accounts.count}"
end
