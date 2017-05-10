module Legacy
  module V2
    module Judge
      class RegionalPitchEventSelectionsController < JudgeController
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
          old_event = current_judge.selected_regional_pitch_event

          current_judge.remove_from_live_event

          SendPitchEventRSVPNotifications.perform_later(
            current_judge.id,
            judge_leaving_event_id: old_event.id
          )

          redirect_to [:judge, :dashboard],
            success: t("controllers.judge.regional_pitch_event_selections.destroy.success")
        end

        def do_create(params)
          old_event = current_judge.selected_regional_pitch_event

          current_judge.remove_from_live_event

          event = RegionalPitchEvent.find(params.fetch(:event_id))
          current_judge.regional_pitch_events << event
          current_judge.save!

          SendPitchEventRSVPNotifications.perform_later(
            current_judge.id,
            judge_leaving_event_id: old_event.id,
            judge_joining_event_id: event.id
          )

          redirect_to [:judge, current_judge.selected_regional_pitch_event],
            success: t("controllers.judge.regional_pitch_event_selections.create.success")
        end
      end
    end
  end
end
