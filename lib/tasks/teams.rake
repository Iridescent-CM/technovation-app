namespace :teams do
  desc "Reconsider divisions"
  task reconsider_divisions: :environment do
    i = 0

    Team.current.find_each do |t|
      division = t.division_name
      reconsider = t.reconsider_division.name

      if division != reconsider
        i += 1
        t.reconsider_division_with_save
        puts "#{t.name} changed #{division} to #{reconsider}"
        puts ""
        puts ""
      end
    end

    puts "Changed divisions for #{i} teams"
  end

  desc "Remove orphaned teams from RPEs no longer in their division"
  task make_orphaned_virtual: :environment do
    Team.current.includes(:regional_pitch_events,
                          team_submissions: :submission_scores).find_each do |t|
      if t.selected_regional_pitch_event.live? and
          not t.selected_regional_pitch_event.division_ids.include?(t.division.id)

        event_name = t.selected_regional_pitch_event_name

        t.remove_from_live_event

        puts "Removed #{t.name} from #{event_name}"
      end
    end
  end

  desc "List all current season team and member location data"
  task location_data_dump: :environment do
    puts "Exporting data..."

    filename =  "./#{Season.current.year}-team-locations-dump.csv"

    CSV.open(filename, 'wb') do |csv|
      csv << %w{
        Team\ name
        Team\ state/province
        Members\ state/province
        Team\ country
        Members\ country
        Submission\ status
      }

      Team.current.includes(memberships: { member: :account }).find_each do |team|
        row = [
          team.name,
          team.state_province,
        ]

        states = team.members.collect(&:state_province).compact
        popular_state = states.max

        countries = team.members.flat_map(&:account).collect { |a| FriendlyCountry.(a) }.compact
        popular_country = countries.max

        next if popular_country == FriendlyCountry.(team) &&
                  popular_state == team.state_province

        puts "Exporting Team##{team.id} location information"

        if states.uniq.count != states.count
          row << popular_state
        else
          row << states.join(', ')
        end

        row << FriendlyCountry.(team)

        if countries.uniq.count != countries.count
          row << popular_country
        else
          row << countries.join(', ')
        end

        row << team.submission.status

        csv << row
      end
    end

    puts "Data exported to #{filename}"
  end

  desc "List all current season technical checlists"
  task technical_checklist_dump: :environment do
    puts "Exporting data..."

    filename =  "./#{Season.current.year}-technical-checklists-dump.csv"

    CSV.open(filename, 'wb') do |csv|
      csv << %w{
        Team\ name
        State/province
        Country
        Submission\ status
        Started?
        Total\ points
        Technical\ components
        Database\ components
        Mobile\ components
        Pics\ of\ process
      }

      Team.current.includes(team_submissions: :technical_checklist).find_each do |team|
        next unless team.submission.present?

        puts "Exporting Team##{team.id} technical checklist information"

        score = SubmissionScore.new(team_submission: team.submission)

        csv << [
          team.name,
          team.state_province,
          FriendlyCountry.(team),
          team.submission.status,
          team.submission.technical_checklist_started? ? "yes" : "no",
          score.total_technical_checklist_verified,
          score.total_coding_verified,
          score.total_db_verified,
          score.total_mobile_verified,
          score.total_process_verified
        ]
      end
    end

    puts "Data exported to #{filename}"
  end
end
