require 'uri'

class ExportJob < ActiveJob::Base
  queue_as :default

  def perform(admin, params)
    send("export_#{params[:class]}s", admin, params)
  end

  private
  def export_accounts(admin, params)
    account_ids = Admin::SearchAccounts.(params).pluck(:id)
    search_text = params[:text].blank? ? "" : URI.escape("-search-query-#{params[:text]}")
    filepath = "./tmp/#{params[:season]}-#{params[:type]}-accounts#{search_text}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{
        User\ type
        Signed\ up
        First\ name
        Last\ name
        Email
        Team\ name(s)
        Division
        Referred\ by
        School/Company\ name
        City
        State
        Country
      }

      account_ids.each do |account_id|
        account = Account.find(account_id)

        csv << [account.type_name, account.created_at, account.first_name, account.last_name,
                account.email, account.teams.current.flat_map(&:name).to_sentence,
                account.division, "#{account.referred_by} #{account.referred_by_other}",
                account.get_school_company_name, account.city, account.state_province,
                FriendlyCountry.(account)]
      end
    end

    export(filepath, admin, params[:export_email])
  end

  def export_regional_pitch_events(admin, params)
    event_ids = RegionalPitchEvent.pluck(:id)
    filepath = "./tmp/2017-regional-pitch-events.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{
        RA
        Name
        Official?
        Senior\ division
        Junior\ division
        Starts\ at
        Ends\ at
        Timezone
        Eventbrite\ link
        Venue\ address
        City
        State/Province
        Country
      }

      event_ids.each do |event_id|
        event = RegionalPitchEvent.find(event_id)

        csv << [event.regional_ambassador_profile.full_name, event.name,
                event.unofficial? ? "no" : "yes",
                event.division_names.include?("senior") ? "yes" : "no",
                event.division_names.include?("junior") ? "yes" : "no",
                event.starts_at.in_time_zone(event.timezone),
                event.ends_at.in_time_zone(event.timezone),
                event.timezone, event.eventbrite_link, event.venue_address,
                event.city, event.state_province, FriendlyCountry.(event)]
      end
    end

    export(filepath, admin, params[:export_email])
  end

  def export_team_submissions(admin, params)
    submission_ids = TeamSubmission.pluck(:id)
    search_text = params[:text].blank? ? "" : URI.escape("-search-query-#{params[:text]}")
    filepath = "./tmp/#{params[:season]}-#{params[:division]}-team-submissions#{search_text}.csv"

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
        Screenshots
        Technical\ checklist
        Source\ code
        Platform
        Business\ plan
      }

      submission_ids.each do |submission_id|
        submission = TeamSubmission.find(submission_id)

        csv << [submission.team_name, submission.team_city, submission.team_state_province,
                FriendlyCountry.(submission.team), submission.status,
                submission.team_division_name, submission.app_name,
                submission.app_description, submission.stated_goal,
                submission.demo_video_link, submission.pitch_video_link,
                submission.screenshots.count,
                submission.technical_checklist_started? ? 'started' : 'not started',
                submission.source_code_url_text, submission.development_platform_text,
                submission.business_plan_url_text]
      end
    end

    export(filepath, admin, params[:export_email])
  end

  def export_regional_ambassadors(admin, params)
    params[:type] = "RegionalAmbassador"
    params[:season] = Season.current.year
    params[:status] ||= "pending"

    ambassador_ids = Account.current.joins(:regional_ambassador_profile).where("regional_ambassador_profiles.status = ?", RegionalAmbassadorProfile.statuses[params[:status]]).pluck(:id)
    filepath = "./tmp/#{params[:season]}-#{params[:type]}-accounts-#{params[:status]}.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Status Signed\ up First\ name Last\ name Email City State Country}

      ambassador_ids.each do |ambassador_id|
        ambassador = Account.find(ambassador_id)

        csv << [ambassador.regional_ambassador_profile.status, ambassador.created_at,
                ambassador.first_name, ambassador.last_name, ambassador.email,
                ambassador.city, ambassador.state_province, FriendlyCountry.(ambassador)]
      end
    end

    export(filepath, admin, params[:export_email])
  end

  def export_teams(admin, params)
    team_ids = Admin::SearchTeams.(params).pluck(:id).uniq
    filepath = "./tmp/#{params[:season]}-#{params[:division]}-teams.csv"

    CSV.open(filepath, 'wb') do |csv|
      csv << %w{Id Division Name Has\ mentor(s) City State Country Student\ emails Mentor\ emails}

      team_ids.each do |team_id|
        team = Team.find(team_id)

        csv << [team.id, team.division_name, team.name,
                team.mentors.any? ? "yes" : "no", team.city, team.state_province,
                FriendlyCountry.(team), team.students.map(&:email).join(','),
                team.mentors.map(&:email).join(',')]
      end
    end

    export(filepath, admin, params[:export_email])
  end

  def export_scores(admin, params)
    send("export_scores_#{params[:type]}", admin, params)
  end

  def export_scores_summary(admin, params)
    Tempfile.open(["score-summary-", ".csv"], "./tmp/") do |fh|
      csv = CSV.new(fh)
      csv << %w{
        Team\ name
        App\ name
        City
        State/Province
        Country
        Division
        Sustainable\ development\ goal
        Submisson\ complete?
        Event\ name
        Event\ type
        Event\ official?
        #\ of\ incomplete\ scores
        #\ of\ completed\ scores
        #\ completed\ live
        #\ completed\ virtual
        Average\ score
      }

      TeamSubmission.current.find_each do |submission|
        next unless submission.complete? or submission.team.selected_regional_pitch_event.live?
        team = submission.team
        rpe = team.selected_regional_pitch_event
        csv << [team.name,
                submission.app_name,
                team.city,
                team.state_province,
                FriendlyCountry.(team),
                team.division.name,
                submission.stated_goal,
                submission.complete? ? "complete" : "incomplete",
                rpe.name,
                rpe.live? ? "live" : "virtual",
                rpe.unofficial? ? "unofficial" : "official",
                submission.submission_scores.incomplete.count,
                submission.submission_scores.complete.count,
                submission.submission_scores.complete.live.count,
                submission.submission_scores.complete.virtual.count,
                submission.average_score]
      end

      csv.close()
      export(fh, admin, params[:export_email])
    end
  end

  def export_scores_detail(admin, params)
    Tempfile.open(["score-detail-", ".csv"], "./tmp/") do |fh|
      csv = CSV.new(fh)
      csv << %w{
        Team\ name
        App\ name
        City
        State/Province
        Country
        Division
        Sustainable\ development\ goal
        Submission\ complete?
        Event\ name
        Event\ type
        Event\ official?
        Judge\ email
        Judge\ name
        Complete?
        Total\ score
        Mentor?
        Team\ region/divisions
      }

      SubmissionScore.current.find_each do |score|
        account = score.judge_profile.account
        submission = score.team_submission
        team = submission.team
        rpe = team.selected_regional_pitch_event

        team_region_divisions = account.team_region_division_names.map {|trd| trd.split(',') }.flatten

        csv << [team.name,
                submission.app_name,
                team.city,
                team.state_province,
                FriendlyCountry.(team),
                team.division.name,
                submission.stated_goal,
                submission.complete? ? "complete" : "incomplete",
                rpe.name,
                rpe.live? ? "live" : "virtual",
                rpe.unofficial? ? "unofficial" : "official",
                account.email,
                account.full_name,
                score.complete?,
                score.total,
                account.mentor_profile.present?] + team_region_divisions
      end

      csv.close()
      export(fh, admin, params[:export_email])
    end
  end

  def export(filepath, admin, email)
    file = File.open(filepath)
    export = admin.exports.create!(file: file)
    FilesMailer.export_ready(admin, export, email).deliver_later
  end
end
