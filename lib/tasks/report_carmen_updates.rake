desc "Dry-run only - create report of how data would change in Carmen update"
task dry_run_carmen: :environment do
  CSV.open("./tmp/carmen-dry-run.csv", "wb") do |rows|
    rows << [
      "ID",
      "Name",
      "Email",
      "Old State",
      "New State",
    ]

    accounts = Account.current.where("length(state_province) > 4")
    puts "Dry run on #{accounts.count} accounts..."
    accounts.each.with_index do |account, i|
      row = [
        account.id,
        account.name,
        account.email,
        account[:state_province],
      ]


      country = Carmen::Country.coded(account[:country])

      case account[:state_province]
      when /madrid/i
        state = country.subregions.named("Madrid", fuzzy: true)
      when /valencia/i
        state = country.subregions.named("Valencia", fuzzy: true)
      else
        state = country.subregions.named(account[:state_province], fuzzy: true)
      end

      account.state_province = state && state.code

      row << account.state_code

      rows << row
      puts i + 1
    end
    puts "Done!"
    puts "Find the report in ./tmp/carmen-dry-run.csv"
  end
end