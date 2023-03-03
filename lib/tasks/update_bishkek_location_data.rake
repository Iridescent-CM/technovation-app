desc "Update Bishkek state location data"
task :update_bishkek_state_location_data, [:dry_run] => :environment do |t, args|
  dry_run = args[:dry_run] != "run"
  puts "DRY RUN: #{dry_run ? 'on' : 'off'}"

  accounts = Account.current.where(country: "KG")
    .where(city: "Bishkek")
    .where("state_province is null or state_province = '' or state_province != 'Gorod Bishkek'")

  puts "Accounts in the city Bishkek, KG that are not in Gorod Bishkek or have incorrect state/province data: #{accounts.count}"

  if !dry_run
    puts "Updating state province now..."
    accounts.find_each do |account|
      puts "===================================="
      puts "Account##{account.id}"
      puts "City: #{account.city}"
      puts "Country: #{account.country}"

      account.update_column(:state_province, "Gorod Bishkek")

      puts "----------- ??? -------------"
      puts "STATE CHANGED"
      puts "State became: `#{account.state}`"

    end

    accounts = Account.current.where(country: "KG")
      .where(city: "Bishkek")
      .where("state_province is null or state_province = '' or state_province != 'Gorod Bishkek'")

    puts "===================================="
    puts "...done!"
    puts "Accounts in the city Bishkek, KG that are in the state/province Gorod Bishkek: #{accounts.count}"
  end
end
