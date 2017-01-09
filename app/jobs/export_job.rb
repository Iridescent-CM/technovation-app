require 'uri'

class ExportJob < ActiveJob::Base
  queue_as :default

  def perform(admin, params)
    token = SecureRandom.urlsafe_base64
    send("export_#{params[:class]}s", admin, token, params)
  end

  private
  def export_accounts(admin, token, params)
    account_ids = Admin::SearchAccounts.(params).pluck(:id)
    search_text = URI.escape("search-query-#{params[:text]}")
    filepath = "./tmp/#{params[:season]}-#{params[:type]}-accounts-#{search_text}-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{User\ type Signed\ up First\ name Last\ name Email Team\ name(s) Division Referred\ by City State Country}

      account_ids.each do |account_id|
        account = Account.find(account_id)

        csv << [account.type_name, account.created_at, account.first_name, account.last_name,
                account.email, account.teams.current.flat_map(&:name).to_sentence,
                account.division, "#{account.referred_by} #{account.referred_by_other}",
                account.city, account.state_province, Country[account.country].name]
      end
    end

    export(filepath, admin, params[:export_email])
  end

  def export_regional_ambassadors(admin, token, params)
    params[:type] = "RegionalAmbassador"
    params[:season] = Season.current.year
    params[:status] ||= "pending"

    ambassador_ids = Account.current.joins(:regional_ambassador_profile).where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[params[:status]]).pluck(:id)
    filepath = "./tmp/#{params[:season]}-#{params[:type]}-accounts-#{params[:status]}-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Status Signed\ up First\ name Last\ name Email City State Country}

      ambassador_ids.each do |ambassador_id|
        ambassador = Account.find(ambassador_id)

        csv << [ambassador.regional_ambassador_profile.status, ambassador.created_at,
                ambassador.first_name, ambassador.last_name, ambassador.email,
                ambassador.city, ambassador.state_province, Country[ambassador.country].name]
      end
    end

    export(filepath, admin, params[:export_email])
  end

  def export_teams(admin, token, params)
    team_ids = Admin::SearchTeams.(params).pluck(:id).uniq
    filepath = "./tmp/#{params[:season]}-#{params[:division]}-teams-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Id Division Name City State Country Member\ emails}

      team_ids.each do |team_id|
        team = Team.find(team_id)

        csv << [team.id, team.division_name, team.name,
                team.city, team.state_province, team.country,
                team.members.map(&:email).join(' ')]
      end
    end

    export(filepath, admin, params[:export_email])
  end

  def export(filepath, admin, email)
    file = File.open(filepath)
    export = admin.exports.create!(file: file)
    FilesMailer.export_ready(admin, export, email).deliver_later
  end
end
