module Admin::Clubs
  class StatusController < AdminController
    include Admin::ChapterableStatusConcern

    before_action :set_chapterable

    private

    def set_chapterable
      @chapterable = Club.find(params[:club_id])
    end
  end
end
