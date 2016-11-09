desc "Update mentor Campaign Monitor list info"
task update_mentor_cm_info: :environment do
  MentorProfile.current.full_access.find_in_batches(batch_size: 100).with_index do |group, batch|
    puts "Updating #{batch + 1}00 mentors..."

    group.each do |mentor|
      auth = { api_key: ENV.fetch('CAMPAIGN_MONITOR_API_KEY') }
      subscriber = CreateSend::Subscriber.new(auth, ENV.fetch("MENTOR_LIST_ID"), mentor.email.strip)
      fields = [{ Key: 'City', Value: mentor.city },
                { Key: 'State/Province', Value: mentor.state_province },
                { Key: 'Country', Value: Country[mentor.country].name }]
      subscriber.update(mentor.email.strip, mentor.full_name, fields, false)
    end

    puts "Sleeping for 5 seconds..."
    sleep 5
  end

  puts "Done!"
end
