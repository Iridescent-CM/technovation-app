module Admin
  class UserInvitationsController < AdminController
    helper_method :invitation_token

    def index
      @user_invitation = UserInvitation.new
      @user_invitations = UserInvitation.order('created_at desc')
        .page(params[:page])
    end

    def new
      @user_invitation = UserInvitation.new
    end

    def create
      @user_invitation = UserInvitation.new(user_invitation_params)

      if @user_invitation.save
        RegistrationMailer.invitation(@user_invitation.id)
          .deliver_later

        redirect_to admin_user_invitations_path,
          success: "You invited " +
                   @user_invitation.profile_type.titleize +
                   ": #{@user_invitation.email} to sign up"
      else
        if @user_invitation.errors[:email].any? { |e|
             e.include?("taken")
           }
          @existing = UserInvitation.find_by(
            email: @user_invitation.email
          )
        end

        render :new
      end
    end

    private

    def user_invitation_params
      params.require(:user_invitation).permit(
        :profile_type,
        :name,
        :email,
        :register_at_any_time
      )
    end

    def invitation_token
      (GlobalInvitation.active.last || NullInvitation.new("")).token
    end

    class NullInvitation < Struct.new(:token)
      def present?
        false
      end
    end
  end
end
