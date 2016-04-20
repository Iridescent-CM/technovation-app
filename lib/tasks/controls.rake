namespace :controls do

  namespace :events do

    desc "Reassign the teams in the event to Virtual Judging"
    task :make_virtual, [:id] => :environment do |t, args|
      event = Event.find(args[:id])
      virtual_event = Event.virtual_for_current_season

      puts "#{event.name} -> #{virtual_event.name}"
      event.teams.each do |team|
        puts "\t#{team.name}"
        team.event_id = virtual_event.id
        team.save!
      end
    end

  end

end
