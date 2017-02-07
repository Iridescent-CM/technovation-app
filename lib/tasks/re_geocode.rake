desc "Re-reverse geocode all accounts"
task re_reverse_geocode: :environment do
  Account.skip_callback(:save, :after, :index_search_engine)

  Account.find_each do |account|
    account.geocoded = account.address_details
    account.reverse_geocode

    puts "Reverse geocoding #{account.id} to #{account.address_details}"

    account.save
  end

  Account.set_callback(:save, :after, :index_search_engine)
end
