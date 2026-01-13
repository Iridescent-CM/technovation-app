module ChapterAmbassador
  class EventTeamsController < ChapterAmbassadorController
    def create
      @event = RegionalPitchEvent.in_region(current_ambassador).find(params[:event_id])
      @team = Team.find(params[:team_id])

      AddTeamToRegionalEvent.call(@event, @team)
      @event = RegionalPitchEvent
        .includes(
          teams: [
            :division,
            :submission
          ]
        )
        .find(params[:event_id])
      @available_teams = load_available_teams_for_event(@event)

      respond_to do |format|
        format.html {
          redirect_to chapter_ambassador_event_path(@event),
            notice: "#{@team.name} added to #{@event.name}."
        }
        format.turbo_stream
      end
    end

    def destroy
      @event = RegionalPitchEvent.in_region(current_ambassador).find(params[:event_id])
      @team = Team.find(params[:id])

      if @event.attendees.include?(@team)
        InvalidateExistingJudgeData.call(@team, removing: true, event: @event)

        @team.memberships.each do |membership|
          EventMailer.notify_removed(
            membership.member_type,
            membership.member_id,
            @event.id,
            team_name: @team.name
          ).deliver_later
        end
      end

      @event = RegionalPitchEvent
        .includes(
          :judges, :user_invitations,
          teams: [
            :division,
            :submission
          ]
        )
        .find(params[:event_id])
      @available_teams = load_available_teams_for_event(@event)

      respond_to do |format|
        format.html {
          redirect_to chapter_ambassador_event_path(@event),
            notice: "Team removed"
        }
        format.turbo_stream
      end
    end
  end
end
