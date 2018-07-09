module SetRequestStatus
  def self.call(request, new_status)
    ActiveRecord::Base.transaction do
      if request.request_status === new_status
        log("SKIP Request##{request.id}: already #{new_status}!")
        false
      else
        request.public_send("#{new_status}!")
        send("after_#{new_status}", request)
      end
    end
  end

  private
  def self.after_pending(request)
    RequestMailer.notify_pending(request.id).deliver_later
  end

  def self.after_approved(request)
    request.requestor_meta["requesting_regions"].each do |region|
      request.requestor.secondary_regions << region
    end

    RequestMailer.notify_approved(request.id).deliver_later
  end

  def self.after_declined(request)
    request.requestor_meta["requesting_regions"].each do |region|
      request.requestor.secondary_regions.delete(region)
    end

    RequestMailer.notify_declined(request.id).deliver_later
  end

  def self.log(msg)
    Rails.logger.info("[SetRequestStatus] " + msg)
  end
end