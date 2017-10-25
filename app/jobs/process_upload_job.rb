class ProcessUploadJob < ActiveJob::Base
  queue_as :default

  def perform(record_id, klass, method_name, key, account_id = nil)
    record = klass.constantize.find(record_id)
    url = "http://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/#{key}"
    record.send("remote_#{method_name}_url=", url)

    case method_name
    when "source_code"
      record.source_code_file_uploaded = true
    end

    case klass
    when "Account"
      record.icon_path = nil
    when "Team"
      account = Account.find(account_id)
      # TODO requirement of team name uniqueness exceptions
      # TODO really threw a wrench here
      record.name_uniqueness_exceptions = account.past_teams.pluck(:name)
    end

    record.save!
  end
end
