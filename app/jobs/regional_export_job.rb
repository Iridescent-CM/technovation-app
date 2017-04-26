class RegionalExportJob < ActiveJob::Base
  queue_as :default

  def perform(ambassador, params)
    send("export_#{params[:class]}", ambassador, params)
  end

  private
  def export_accounts(ambassador, params)
    account_ids = RegionalAccount.(ambassador, params).pluck(:id)
    filepath = "./tmp/#{Season.current.year}-#{ambassador.region_name}-#{params[:type]}-accounts.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Signup\ date
                Last\ updated
                User\ type
                First\ name
                Last\ name
                Email
                Parent\ Email
                Team\ name(s)
                School\ /\ company\ name
                Division
                City
                State\ /\ Province
                Country}

      account_ids.each do |account_id|
        account = Account.find(account_id)

        csv << [account.created_at.to_date, account.updated_at.to_date,
                account.type_name, account.first_name, account.last_name,
                account.email, account.parent_email,
                account.teams.current.flat_map(&:name).to_sentence,
                account.get_school_company_name, account.division, account.city,
                account.state_province, Country[account.country].name]
      end
    end

    export(filepath, ambassador)
  end

  def export_teams(ambassador, params)
    team_ids = RegionalTeam.(ambassador, params).select(:id, :created_at).uniq
    mentor_status = URI.escape("mentor-status-#{params[:mentor_status]}")
    filepath = "./tmp/#{Season.current.year}-#{ambassador.region_name}-#{params[:division]}-teams-#{mentor_status}.csv"

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

  def export_team_submissions(ambassador, params)
    submission_ids = RegionalAmbassador::SearchTeamSubmissions.(params, ambassador)
      .select(&:id)
      .uniq
    filepath = "./tmp/#{Season.current.year}-#{ambassador.region_name}-Team_Submissions-Division_#{params[:division]}-SustainableDevGaol_#{params[:sdg]}-HasName_#{params[:has_name]}-TechCheckListStarted_#{params[:technical_checklist]}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{
        Team\ name
        City
        State/Province
        Country
        Status
        Division
        App\ name
        Description
        SDG
        Demo\ video
        Pitch\ video
        Screenshot\ count
        Technical\ checklist\ status
        Source\ code
        Platform
        Business\ plan
        Submission\ url
        Team\ url
      }

      submission_ids.each do |sub_id|
        sub = TeamSubmission.includes(
          :screenshots, :business_plan, :technical_checklist,
          { team: :division }
        ).find(sub_id)

        csv << [sub.team_name, sub.team_city, sub.team_state_province, sub.team_country,
                sub.status, sub.team_division_name, sub.app_name, sub.app_description,
                sub.stated_goal, sub.demo_video_link, sub.pitch_video_link,
                sub.screenshots.count,
                (sub.technical_checklist_started? ? 'started' : 'not started'),
                sub.source_code_url_text, sub.development_platform_text,
                sub.business_plan_url_text,
                Rails.application.routes.url_helpers.app_url(sub),
                Rails.application.routes.url_helpers.team_url(sub.team)]
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
