module JoinRequestApproved
  def self.call(join_request)
    join_request.update(accepted_at: Time.current)

    if join_request.requestor_scope_name == "student"
      others = JoinRequest.pending.where(requestor_id: join_request.requestor_id)
      others.each(&:destroy)
    end

    TeamRosterManaging.add(join_request.team, join_request.requestor)

    if join_request.requestor_scope_name == "mentor"
      MentorToTeamChapterableAssigner.new(mentor_profile: join_request.requestor, team: join_request.team).call
    end

    TeamMailer.public_send(
      :"#{join_request.requestor_scope_name}_join_request_accepted",
      join_request
    ).deliver_later
  end
end
