desc "Print the count of location confirmed accounts"
task count_location_confirmed: :environment do
  puts "# of Accounts with location confirmed: #{Account.where(location_confirmed: true).count}"
end
