module Admin
  class UserInvitationEmailsController < AdminController
    def create
      @user_invitation = UserInvitation.sent.find(params[:invitation_id])
      RegistrationMailer.admin_permission(@user_invitation.id).deliver_later
      redirect_to admin_user_invitations_path,
        success: "You re-sent the #{@user_invitation.profile_type.titleize} invitation to #{@user_invitation.email}"
    end
  end
end
