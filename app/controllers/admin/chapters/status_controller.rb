module Admin::Chapters
  class StatusController < AdminController
    include Admin::ChapterableStatusConcern

    before_action :set_chapterable

    private

    def set_chapterable
      @chapterable = Chapter.find(params[:chapter_id])
    end
  end
end
