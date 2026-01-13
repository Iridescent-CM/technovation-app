module ChapterAmbassador
  class EventJudgesController < ChapterAmbassadorController
    def create
      @event = RegionalPitchEvent.in_region(current_ambassador).find(params[:event_id])
      @judge = JudgeProfile.find(params[:judge_id])

      @judge.events << @event

      @event = RegionalPitchEvent.find(params[:event_id])
      @available_judges = load_available_judges_for_event(@event)

      respond_to do |format|
        format.html {
          redirect_to chapter_ambassador_event_path(@event),
            notice: "#{@judge.name} added to #{@event.name}."
        }
        format.turbo_stream
      end
    end

    def destroy
      @event = RegionalPitchEvent.in_region(current_ambassador).find(params[:event_id])
      @judge = JudgeProfile.includes(:current_account).find(params[:id])

      if @event.attendees.include?(@judge)
        InvalidateExistingJudgeData.call(@judge, removing: true, event: @event)

        EventMailer.notify_removed(
          "JudgeProfile",
          @judge.id,
          @event.id
        ).deliver_later
      end

      @event = RegionalPitchEvent.find(params[:event_id])
      @available_judges = load_available_judges_for_event(@event)

      respond_to do |format|
        format.html {
          redirect_to chapter_ambassador_event_path(@event),
            notice: "Judge removed"
        }
        format.turbo_stream
      end
    end
  end
end
