module Admin
  class ChaptersController < AdminController
    include DatagridController
    use_datagrid with: ChaptersGrid

    def show
      @chapter = Chapter.find(params[:id])
      @chapter_invite = UserInvitation.new
      @pending_chapter_invites = UserInvitation.pending.where(chapter_id: params[:id])
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

    def update
      @chapter = Chapter.find(params[:id])
      @chapter_invite = UserInvitation.new
      @pending_chapter_invites = UserInvitation.pending.where(chapter_id: params[:id])

      if @chapter.update(chapter_params)
        redirect_to admin_chapter_path(@chapter), success: "Chapter details were updated successfully."
      else
        flash.now[:error] = "There was an issue updating this chapter, please check below."

        render :show
      end
    end

    private

    def chapter_params
      params.require(:chapter).permit(
        :id,
        :organization_name,
        :legal_contact_full_name,
        :legal_contact_email_address,
        :legal_contact_phone_number,
        :legal_contact_job_title
      )
    end

    def grid_params
      grid = params[:chapters_grid] ||= {}

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
