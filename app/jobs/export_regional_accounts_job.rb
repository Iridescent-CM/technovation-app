class ExportRegionalAccountsJob < ActiveJob::Base
  queue_as :default

  def perform(ambassador)
    accounts = RegionalAccount.(ambassador)
    token = SecureRandom.urlsafe_base64
    filepath = "./tmp/#{Season.current.year}-regional-accounts-#{ambassador.full_name.gsub(' ', '-')}-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{ID User\ type First\ name Last\ name Email Team\ name(s) School\ /\ company\ name Division}

      accounts.each do |account|
        csv << [account.id, account.type_name, account.first_name, account.last_name,
                account.email, account.teams.flat_map(&:name).to_sentence,
                account.get_school_company_name, account.division]
      end
    end

    file = File.open(filepath)
    export = ambassador.account_exports.create!(file: file)

    FilesMailer.export_ready(ambassador, export).deliver_later
  end
end
