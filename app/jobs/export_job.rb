class ExportJob < ActiveJob::Base
  queue_as :default

  def perform(admin, params)
    token = SecureRandom.urlsafe_base64
    send("export_#{params[:class]}s", admin, token, params)
  end

  private
  def export_accounts(admin, token, params)
    accounts = Admin::SearchAccounts.(params)
    filepath = "./tmp/#{params[:season]}-#{params[:type]}-accounts-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Id User\ type First\ name Last\ name Email Team\ name(s) Division City State Country}

      accounts.each do |account|
        csv << [account.id, account.type_name, account.first_name, account.last_name,
                account.email, account.teams.current.flat_map(&:name).to_sentence,
                account.division, account.city, account.state_province,
                Country[account.country].name]
      end
    end

    export(filepath, admin)
  end

  def export_teams(admin, token, params)
    teams = Admin::SearchTeams.(params)
    filepath = "./tmp/#{params[:season]}-#{params[:division]}-teams-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Id Division Name City State Country}

      teams.each do |team|
        csv << [team.id, team.division_name, team.name, team.city,
                team.state_province, team.country]
      end
    end

    export(filepath, admin)
  end

  def export(filepath, admin)
    file = File.open(filepath)
    export = admin.exports.create!(file: file)
    FilesMailer.export_ready(admin, export).deliver_later
  end
end
