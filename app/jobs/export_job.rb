require 'uri'

class ExportJob < ActiveJob::Base
  queue_as :default

  def perform(admin, params)
    token = SecureRandom.urlsafe_base64
    send("export_#{params[:class]}s", admin, token, params)
  end

  private
  def export_accounts(admin, token, params)
    accounts = Admin::SearchAccounts.(params)
    search_text = URI.escape("search-query-#{params[:text]}")
    filepath = "./tmp/#{params[:season]}-#{params[:type]}-accounts-#{search_text}-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{User\ type Signed\ up First\ name Last\ name Email Team\ name(s) Division Referred\ by City State Country}

      accounts.each do |account|
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

    ambassadors = Account.current.joins(:regional_ambassador_profile).where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[params[:status]])
    filepath = "./tmp/#{params[:season]}-#{params[:type]}-accounts-#{params[:status]}-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Status Signed\ up First\ name Last\ name Email City State Country}

      ambassadors.each do |ambassador|
        csv << [ambassador.regional_ambassador_profile.status, ambassador.created_at,
                ambassador.first_name, ambassador.last_name, ambassador.email,
                ambassador.city, ambassador.state_province, Country[ambassador.country].name]
      end
    end

    export(filepath, admin, params[:export_email])
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

    export(filepath, admin, params[:export_email])
  end

  def export_signup_attempts(admin, token, params)
    attempts = SignupAttempt.send(params[:status])
    filepath = "./tmp/#{Season.current.year}-signup-attempts-#{params[:status]}-#{token}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{email status}

      attempts.each do |attempt|
        csv << [attempt.email, attempt.status]
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
