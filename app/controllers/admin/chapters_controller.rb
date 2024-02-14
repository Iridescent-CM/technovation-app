module Admin
  class ChaptersController < AdminController
    def index
      @chapters = Chapter.all
    end

    def show
      @chapter = Chapter.find(params[:id])
    end

    def new
      @chapter = Chapter.new
    end

    def create
      chapter = Chapter.new(chapter_params)

      if chapter.save
        redirect_to admin_chapter_path(chapter), success: "#{chapter.organization_name} was added as a new chapter."
      else
        render :new
      end
    end

    private

    def chapter_params
      params.require(:chapter).permit(
        :id,
        :organization_name
      )
    end
  end
end
