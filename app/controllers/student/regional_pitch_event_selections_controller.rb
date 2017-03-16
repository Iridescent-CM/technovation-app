module Student
  class RegionalPitchEventSelectionsController < StudentController
    def show
      if params[:event_id]
        do_create(params)
      else
        do_destroy
      end
    end

    def create
      do_create(params)
    end

    def destroy
      do_destroy
    end

    private
    def do_destroy
      notify_ambassador_of_leaving_team
      confirm_leaving_with_team_members
      current_team.regional_pitch_events.destroy_all

      redirect_to [:student, :dashboard],
        success: t("controllers.student.regional_pitch_event_selections.destroy.success")
    end

    def do_create(params)
      notify_ambassador_of_leaving_team
      confirm_leaving_with_team_members

      current_team.regional_pitch_events.destroy_all
      event = RegionalPitchEvent.find(params.fetch(:event_id))
      current_team.regional_pitch_events << event
      current_team.save!

      AmbassadorMailer.team_joined_event(
        event.regional_ambassador_profile.account,
        event,
        current_team
      ).deliver_later

      current_team.members.each do |member|
        TeamMailer.confirm_joined_event(member, event).deliver_later
      end

      redirect_to [:student, current_team.selected_regional_pitch_event],
        success: t("controllers.student.regional_pitch_event_selections.create.success")
    end

    def notify_ambassador_of_leaving_team
      event = current_team.selected_regional_pitch_event

      if event.live?
        AmbassadorMailer.team_left_event(
          event.regional_ambassador_profile.account,
          event,
          current_team
        ).deliver_later
      end
    end

    def confirm_leaving_with_team_members
      event = current_team.selected_regional_pitch_event

      if event.live?
        current_team.members.each do |member|
          TeamMailer.confirm_left_event(member, event).deliver_later
        end
      end
    end
  end
end
