desc "Update mentor Campaign Monitor list info"
task update_mentor_cm_info: :environment do
  MentorProfile.current.onboarded.each do |mentor|
    auth = { api_key: ENV.fetch('CAMPAIGN_MONITOR_API_KEY') }
    subscriber = CreateSend::Subscriber.new(auth, ENV.fetch("MENTOR_LIST_ID"), mentor.email.strip)
    fields = [{ Key: 'City', Value: mentor.city },
              { Key: 'State/Province', Value: mentor.state_province },
              { Key: 'Country', Value: Country[mentor.country].name }]
    begin
      subscriber.update(mentor.email.strip, mentor.full_name, fields, false)
      puts "Updated #{mentor.email.strip}"
    rescue => e
      puts e.message
      next
    end
  end

  puts "Done!"
end
