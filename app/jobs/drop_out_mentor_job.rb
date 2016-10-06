class DropOutMentorJob < ActiveJob::Base
  queue_as :default

  def perform(mentor)
    mentor.current_season_registration.dropped_out!
    puts "#{mentor.full_name} season registration marked as dropped out!"

    auth = { api_key: ENV.fetch('CAMPAIGN_MONITOR_API_KEY') }

    begin
      CreateSend::Subscriber.new(auth, ENV.fetch("MENTOR_LIST_ID"), mentor.email).delete
    rescue => e
      puts "ERROR UNSUBSCRIBING: #{e.message}"
    end
    puts "#{mentor.full_name} unsubscribed from newsletter!"

    mentor.memberships.current(mentor).destroy_all
    puts "#{mentor.full_name} removed from any Season #{Season.current.year} teams!"

    mentor.mentor_profile.update_column(:searchable, false)
    puts "#{mentor.full_name} marked as NOT searchable!"
  end
end
