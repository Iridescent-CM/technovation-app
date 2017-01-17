class RegionalExportJob < ActiveJob::Base
  queue_as :default

  def perform(ambassador, params)
    token = SecureRandom.urlsafe_base64
    send("export_#{params[:class]}", ambassador, token, params)
  end

  private
  def export_accounts(ambassador, token, params)
    account_ids = RegionalAccount.(ambassador, params).pluck(:id)
    filepath = "./tmp/#{Season.current.year}-#{ambassador.region_name}-#{params[:type]}-accounts-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Id Signup\ date User\ type First\ name Last\ name Email Team\ name(s) School\ /\ company\ name Division City State\ /\ Province Country}

      account_ids.each do |account_id|
        account = Account.find(account_id)

        csv << [account.id, account.created_at.to_date, account.type_name,
                account.first_name, account.last_name, account.email,
                account.teams.current.flat_map(&:name).to_sentence,
                account.get_school_company_name, account.division, account.city,
                account.state_province, Country[account.country].name]
      end
    end

    export(filepath, ambassador)
  end

  def export_teams(ambassador, token, params)
    team_ids = RegionalTeam.(ambassador, params).select(:id).uniq
    mentor_status = URI.escape("mentor-status-#{params[:mentor_status]}")
    filepath = "./tmp/#{Season.current.year}-#{ambassador.region_name}-#{params[:division]}-teams-#{mentor_status}-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Id Division Name City State Country}

      team_ids.each do |team_id|
        team = Team.find(team_id)

        csv << [team.id, team.division_name, team.name, team.city,
                team.state_province, team.country]
      end
    end

    export(filepath, ambassador)
  end

  def export(filepath, ambassador)
    file = File.open(filepath)
    export = ambassador.exports.create!(file: file)
    FilesMailer.export_ready(ambassador, export).deliver_later
  end
end
