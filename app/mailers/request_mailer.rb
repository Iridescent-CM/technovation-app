class RequestMailer < ApplicationMailer
  def notify_pending(request_id)
    request = Request.find(request_id)

    @name = request.requestor_name
    @regions_requested = request.requestor_meta["requesting_regions"]

    Account.full_admin.each do |admin|
      mail to: admin.email, subject: "Region request pending"
    end
  end

  def notify_approved(request_id)
    request = Request.find(request_id)

    @name = request.requestor_name
    @status = request.request_status
    @regions_requested = request.requestor_meta["requesting_regions"]

    mail to: request.requestor_email, subject: "Region request approved"
  end

  def notify_declined(request_id)
    request = Request.find(request_id)

    @name = request.requestor_name
    @status = request.request_status
    @regions_requested = request.requestor_meta["requesting_regions"]

    mail to: request.requestor_email, subject: "Region request declined"
  end
end
