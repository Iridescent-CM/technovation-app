namespace :controls do
  namespace :judges do
    desc "Enable judges of virtual events to become semifinals judges"
    task enable_semifinals_on_virtual: :environment do
      judges = User.where(year: Setting.year).select(&:virtual_judge?)

      judges.each do |j|
        $stdout.write("Enabling semifinals for #{j.email}\n")
        j.update_attributes(semifinals_judge: true)
      end
    end
  end

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
