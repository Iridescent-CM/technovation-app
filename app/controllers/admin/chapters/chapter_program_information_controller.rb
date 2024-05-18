module Admin::Chapters
  class ChapterProgramInformationController < AdminController
    def show
      @chapter = Chapter.find(params[:chapter_id])
    end
  end
end