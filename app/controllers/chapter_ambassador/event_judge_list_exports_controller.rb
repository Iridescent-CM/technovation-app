module ChapterAmbassador
  class EventJudgeListExportsController < ChapterAmbassadorController
    def create
      ExportEventAttendeesJob.perform_later(
        current_ambassador.id,
        params.fetch(:id),
        self.class.name,
        "judge_list"
      )
      render json: {}
    end
  end
end
