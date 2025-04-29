desc "Assign teams to RPE"
task assign_teams_to_rpe: :environment do |task, args|
  rpe = RegionalPitchEvent.find(args.extras.last)

  puts "Assigning teams to RPE #{rpe.name} (ID #{rpe.id})"
  args.extras[0..-2].each do |team_id|
    team = Team.find(team_id)

    if team.blank?
      puts "#{team_id} could not be found"
    elsif !team.current_season?
      puts "#{team.name} is not a part of the current season"
    elsif team.submission.blank?
      puts "#{team.name} does not have a submission"
    elsif team.events.include?(rpe)
      puts "#{team.name} is already assigned to this event"
    elsif team.events.present?
      puts "#{team.name} is already assigned to another event"
    else
      team.events << rpe

      puts "Assigned #{team.name} to #{rpe.name}"
    end
  end
end
