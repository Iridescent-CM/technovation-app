module Admin
  class UserInvitationsController < AdminController
    helper_method :invitation_token

    def index
      @user_invitation = UserInvitation.new
      @user_invitations = UserInvitation.order('created_at desc')
        .page(params[:page])

      if SeasonToggles.judging_enabled?
        @profile_types = UserInvitation.profile_types.except(:student, :mentor)
      else
        @profile_types = UserInvitation.profile_types
      end
    end

    def new
      @user_invitation = UserInvitation.new

      if SeasonToggles.judging_enabled?
        @profile_types = UserInvitation.profile_types.except(:student, :mentor)
      else
        @profile_types = UserInvitation.profile_types
      end
    end

    def create
      @user_invitation = UserInvitation.new(user_invitation_params)

      if SeasonToggles.judging_enabled?
        @profile_types = UserInvitation.profile_types.except(:student, :mentor)
      else
        @profile_types = UserInvitation.profile_types
      end

      if @user_invitation.save
        RegistrationMailer.admin_permission(@user_invitation.id)
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
        :email,
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
