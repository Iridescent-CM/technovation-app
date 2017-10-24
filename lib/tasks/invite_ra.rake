require "./lib/invite_ra"

task invite_ras: :environment do
  ActiveRecord::Base.transaction do
    CSV.foreach(
      "./lib/2018_ra_import.csv",
      headers: true,
      header_converters: :symbol
    ) do |row|
      next if row[:date_of_birth].blank? || row[:bio].blank?

      row[:date_of_birth] = Date.strptime(row[:date_of_birth], "%m/%d/%Y")

      InviteRA.(row)
    end
  end
end
