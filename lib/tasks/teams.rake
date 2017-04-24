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

        t.team_submissions.flat_map(&:submission_scores).each(&:destroy)
        t.judge_assignments.destroy_all
        t.regional_pitch_events.destroy_all

        puts "Removed #{t.name} from #{event_name}"
      end
    end
  end
end
