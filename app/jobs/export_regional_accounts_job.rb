class ExportRegionalAccountsJob < ActiveJob::Base
  queue_as :default

  def perform(ambassador)
    accounts = RegionalAccount.(ambassador)
    filename = "./public/#{Season.current.year}-regional-accounts-#{ambassador.full_name.gsub(' ', '-')}-#{ambassador.consent_token}.csv"

    CSV.open(filename, 'wb') do |csv|
      csv << %w{ID User\ type First\ name Last\ name Email Team\ name(s) School\ /\ company\ name Division}

      accounts.each do |account|
        csv << [account.id, account.type_name, account.first_name, account.last_name,
                account.email, account.teams.flat_map(&:name).to_sentence,
                account.get_school_company_name, account.division]
      end
    end

    FilesMailer.export_ready(ambassador, filename).deliver_later
  end
end
