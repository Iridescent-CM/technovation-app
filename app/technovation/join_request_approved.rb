module JoinRequestApproved
  def self.call(join_request)
    join_request.update(accepted_at: Time.current)

    if join_request.requestor_scope_name == "student"
      others = JoinRequest.pending.where(requestor_id: join_request.requestor_id)
      others.each(&:destroy)
    end

    TeamRosterManaging.add(join_request.team, join_request.requestor)

    if join_request.requestor_scope_name == "mentor"
      student_chapterables = join_request.team.students.flat_map { |s| s.account.current_chapterable_assignment&.chapterable }.uniq

      student_chapterables.each do |chapterable|
        if chapterable.present?
          chapterable_type = chapterable.is_a?(Club) ? "club" : "chapter"
          chapterable.send("#{chapterable_type}_account_assignments").create(
            profile: join_request.requestor,
            account: join_request.requestor.account,
            season: Season.current.year,
            primary: false
          )
        end
      end
    end

    TeamMailer.public_send(
      :"#{join_request.requestor_scope_name}_join_request_accepted",
      join_request
    ).deliver_later
  end
end
