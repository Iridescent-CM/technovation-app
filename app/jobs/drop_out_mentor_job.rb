class DropOutMentorJob < ActiveJob::Base
  queue_as :default

  def perform(mentor)
    mentor.account.update(
      seasons: mentor.account.seasons - [Season.current.year]
    )

    auth = { api_key: ENV.fetch('CAMPAIGN_MONITOR_API_KEY') }

    begin
      CreateSend::Subscriber.new(
        auth,
        ENV.fetch("MENTOR_LIST_ID"),
        mentor.email
      ).delete
    rescue => e
      Rails.logger.error(
        "ERROR UNSUBSCRIBING: #{e.message}"
      )
    end

    Rails.logger.info(
      "#{mentor.full_name} unsubscribed from newsletter!"
    )

    mentor.current_teams.each do |team|
      team.memberships.where(member: mentor).destroy_all
    end

    Rails.logger.info(
      "#{mentor.full_name} removed from any Season #{Season.current.year} teams!"
    )

    mentor.update_column(:searchable, false)

    Rails.logger.info(
      "#{mentor.full_name} marked as NOT searchable!"
    )
  end
end
