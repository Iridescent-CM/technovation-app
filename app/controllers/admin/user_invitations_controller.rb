module Admin
  class UserInvitationsController < AdminController
    include DatagridController

    use_datagrid with: UserInvitationsGrid

    before_action :new_invitation, only: :index

    def new
      @user_invitation = UserInvitation.new
    end

    def create
      if user_invitation_params[:profile_type] == "chapter_ambassador"
        user_invitation_params.merge(register_at_any_time: true)
      end

      @user_invitation = UserInvitation.new(user_invitation_params.merge({invited_by_id: current_account.id}))

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

    def destroy
      invite = UserInvitation.find(params.fetch(:id))

      invite.destroy

      redirect_to admin_user_invitations_path,
        success: "You deleted the invitation to #{invite.email}"
    end

    private

    def new_invitation
      @user_invitation = UserInvitation.new
    end

    def grid_params
      grid = params[:user_invitations_grid] ||= {}

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end

    def user_invitation_params
      params.require(:user_invitation).permit(
        :profile_type,
        :name,
        :email,
        :register_at_any_time,
        :chapter_id,
        :club_id
      )
    end
  end
end
