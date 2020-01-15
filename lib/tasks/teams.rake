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

        InvalidateExistingJudgeData.(t)

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
        row = [team.name]

        states = team.members.collect(&:state_province).compact
        countries = team.members.flat_map(&:account).collect { |a| FriendlyCountry.(a) }.compact

        next if [team.state_province] == states.uniq and
                  [FriendlyCountry.(team)] == countries.uniq

        row <<  team.state_province

        members_state_entry = if states.uniq.count != states.count
                                state_counts = states.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
                                states.max_by { |v| state_counts[v] }
                              else
                                states.join(', ')
                              end

        members_country_entry = if countries.uniq.count != countries.count
                                  country_counts = countries.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
                                  countries.max_by { |v| country_counts[v] }
                                else
                                  countries.join(', ')
                                end

        next if members_state_entry == team.state_province and
                  members_country_entry == FriendlyCountry.(team)

        puts "Exporting Team##{team.id} location information"

        row << members_state_entry
        row << FriendlyCountry.(team)
        row << members_country_entry
        row << team.submission.status

        csv << row
      end
    end

    puts "Data exported to #{filename}"
  end
end
