module JoinRequestApproved
  def self.call(join_request)
    join_request.update_attributes(accepted_at: Time.current)

    if join_request.requestor_scope_name == 'student'
      others = JoinRequest.pending.where(requestor_id: join_request.requestor_id)
      others.each(&:destroy)
    end

    TeamRosterManaging.add(join_request.joinable, join_request.requestor)

    TeamMailer.public_send(
      "#{join_request.requestor_scope_name}_join_request_accepted",
      join_request
    ).deliver_later
  end
end
