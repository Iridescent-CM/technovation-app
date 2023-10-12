module CreateEventAssignment
  def self.call(event, assignment_params)
    invite_params = assignment_params.fetch(:invites)
    invited_by_id = assignment_params[:invited_by_id]

    invite_params.each do |_, par|
      # params come in strange
      # FIXME in EventJudgeList.vue#saveAssignments form appending...
      # FIXME in EventTeamList.vue#saveAssignments form appending...
      opts = par.first

      unless invite = opts[:scope].constantize.find_by(id: opts[:id])
        invite = opts[:scope].constantize.create!({
          email: opts[:email],
          name: opts[:name],
          profile_type: :judge,
          invited_by_id: invited_by_id
        });
      end

      unless invite.events.include?(event)
        InvalidateExistingJudgeData.(invite)
        invite.events << event
      end

      # FIXME "true" == ...
      # make it a real boolean
      if "true" == opts[:send_email]
        if opts[:scope] == "Team"
          invite.memberships.each do |membership|
            EventMailer.invite(
              membership.member_type,
              membership.member_id,
              event.id,
            ).deliver_later
          end
        else
          EventMailer.invite(
            opts[:scope],
            invite.id,
            event.id,
          ).deliver_later
        end
      end
    end
  end
end
