require "csv"

namespace :salesforce do
  task add_platform_ids_to_csv: :environment do
    input_file = "original.csv"
    output_file = "results.csv"

    csv_data = CSV.table(input_file, headers: true)

    csv_data.each do |row|
      email_address = row[:email_address]
      account = Account.find_by(email: email_address.downcase)

      if account.present?
        row[:first_name] = account.first_name
        row[:last_name] = account.last_name
        row[:platform_id] = account.id
      else
        puts "Could not find #{email_address}"
      end
    end

    CSV.open(output_file, "w") do |csv|
      csv << csv_data.headers.map do |header|
        if header == :platform_id
          "Platform Id"
        else
          header.to_s.titlecase
        end
      end

      csv_data.each do |row|
        csv << row
      end
    end
  end
end
