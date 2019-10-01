class SubscribeEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(email, list_scope, merge_fields = {})
    begin
      list = Mailchimp::MailingList.new(list_scope)
      list.subscribe(email, merge_fields)
    rescue Mailchimp::APIRequestError => e
      p "Error: #{e}"
    end
  end
end
