module Api::Registration
  class ChapterOrganizationNamesController < ActionController::API
    def show
      invite = UserInvitation.find_by(admin_permission_token: params[:invite_code])

      render json: {
        chapterOrganizationName: invite.chapter.organization_name
      }
    end
  end
end
