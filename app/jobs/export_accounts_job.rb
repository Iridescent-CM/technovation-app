class ExportAccountsJob < ActiveJob::Base
  queue_as :default

  def perform(admin, params)
    accounts = Admin::SearchAccounts.(params)
    token = SecureRandom.urlsafe_base64
    filepath = "./tmp/#{params[:season]}-#{params[:type]}-accounts-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Id User\ type First\ name Last\ name Email Team\ name(s) Division City State Country}

      accounts.each do |account|
        csv << [account.id, account.type_name, account.first_name, account.last_name,
                account.email, account.teams.flat_map(&:name).to_sentence,
                account.division, account.city, account.state_province,
                account.country]
      end
    end

    file = File.open(filepath)
    export = admin.account_exports.create!(file: file)

    FilesMailer.export_ready(admin, export).deliver_later
  end
end
