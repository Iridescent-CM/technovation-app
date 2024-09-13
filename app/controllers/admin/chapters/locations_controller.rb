module Admin::Chapters
  class LocationsController < AdminController
    def edit
      @chapter = Chapter.find(params[:chapter_id])
    end
  end
end
