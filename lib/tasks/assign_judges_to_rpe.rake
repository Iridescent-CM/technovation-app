desc "Assign judges to RPE"
task assign_judges_to_rpe: :environment do |task, args|
  rpe = RegionalPitchEvent.find_by(id: args.extras.last)

  if rpe.blank?
    raise "Could not find RPE with ID: #{args.extras.last}"
  end

  puts "Assigning judges to RPE #{rpe.name} (ID #{rpe.id})"
  args.extras[0..-2].each do |email_address|
    account = Account.find_by(email: email_address)
    judge_profile = account.judge_profile

    if account.blank?
      puts "Could not find account with email address: #{email_address}"
    elsif judge_profile.blank?
      puts "#{email_address} is not a judge"
    elsif !account.current_season?
      puts "#{email_address} is not registered to the current season"
    elsif judge_profile.events.include?(rpe)
      puts "#{email_address} is already assigned to this event"
    else
      judge_profile.events << rpe

      puts "Assigned #{email_address} to #{rpe.name}"
    end
  end
end
