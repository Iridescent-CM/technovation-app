module JoinRequestDeclined
  def self.call(join_request)
    join_request.update_attributes(declined_at: Time.current)

    TeamMailer.public_send(
      "#{join_request.requestor_scope_name}_join_request_declined",
      join_request
    ).deliver_later
  end
end
