desc "Reverse geocode all current accounts with an empty state"
task fix_empty_states: :environment do
  accounts = Account.current.where(state_province: nil)
    .where.not(country: nil)

  puts "Accounts with empty states: #{accounts.count}"
  puts "Reverse geocoding now..."

  accounts.find_each do |account|
    account.reverse_geocode
    account.save
  end

  accounts = Account.current.where(state_province: nil)
    .where.not(country: nil)

  puts "...done!"
  puts "Accounts with empty states: #{accounts.count}"
end