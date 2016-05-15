namespace :controls do
  namespace :judges do
    desc "Enable judges of virtual events to become semifinals judges"
    task enable_semifinals_on_virtual: :environment do
      judges = User.includes(:event).is_registered.select(&:virtual_judge?)

      judges.each do |j|
        $stdout.write("Enabling semifinals for #{j.email}\n")
        j.update_attributes(semifinals_judge: true)
      end

      $stdout.write("Enabled #{judges.count} judges\n")
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

  namespace :rubrics do
    desc "Create rubric for all judges who attended in-person event but moved for virtual events to judge semifinals"
    task :crete_rubrics_for_in_person_events, [:event_id, :judge_id] => :environment do |t, args|
      event = Event.find(args[:event_id])
      $stdout.write("Creating rubric for event #{event.name}:")
      judge = User.find(args[:judge_id])
      teams_with_no_rubric = event.teams
                              .where(year: 2016)
                              .select{|t| t.rubrics.where("extract(year from created_at) = ?", 2016)
                                  .where(stage: 'quarterfinal', user_id: judge.id).empty?
                              }
      teams_with_no_rubric.each do |team|
        Rubric.new(user_id: judge.id, team_id: team.id,
          stage: 0, competition: 0, identify_problem: 0, address_problem: 0, functional: 0,
          external_resources: 0, match_features: 0, interface: 0, description: 0, market: 0,
          revenue: 0, branding: 0, pitch: 0)
          .save!
        $stdout.write("Rubric created for judge: #{judge.email} and team: #{team.name}\n")
      end
    end
  end

end
