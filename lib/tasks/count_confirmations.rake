desc "Print the count of location confirmed accounts"
task count_location_confirmed: :environment do
  puts "# of Accounts with location confirmed: #{Account.where(location_confirmed: true).count}"
end

desc "Print the count of browser names"
task count_browsers: :environment do
  puts Account.current.each_with_object(Hash.new(0)) { |a, h| h[a.browser_name] += 1 }
end
