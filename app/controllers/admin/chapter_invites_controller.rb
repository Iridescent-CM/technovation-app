module Admin
  class ChapterInvitesController < AdminController
    def create
      @chapter_invite = UserInvitation.new(
        invite_params.merge({
          profile_type: "chapter_ambassador",
          register_at_any_time: true,
          chapter_id: params[:chapter_id],
          invited_by_id: current_account.id
        })
      )

      if @chapter_invite.save
        RegistrationMailer.invitation(@chapter_invite.id)
          .deliver_later

        redirect_to admin_chapter_path(params[:chapter_id]),
          success: "You successfully invited #{@chapter_invite.name.presence || @chapter_invite.email} to this chapter!"
      else
        @chapter = Chapter.find(params[:chapter_id])

        render "admin/chapters/show"
      end
    end

    private

    def invite_params
      params.require(:user_invitation).permit(
        :name,
        :email
      )
    end
  end
end
