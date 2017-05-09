module TeamController
  extend ActiveSupport::Concern

  included do
    helper_method :account_type
  end

  def show
    @team = current_profile.teams.find(params.fetch(:id))
    @team_member_invite = TeamMemberInvite.new(team_id: @team.id)
    @uploader = ImageUploader.new
    @uploader.success_action_redirect = send("#{current_account.type_name}_team_photo_upload_confirmation_url", team_id: @team.id, back: request.fullpath)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      RegisterToCurrentSeasonJob.perform_later(@team)
      @team.public_send("add_#{account_type}", current_profile)

      redirect_to [account_type, @team],
        success: t("controllers.teams.create.success")
    else
      render :new
    end
  end

  def edit
    @team = current_profile.teams.find(params.fetch(:id))
  end

  def update
    @team = current_profile.teams.find(params.fetch(:id))

    if @team.update_attributes(team_params)
      redirect_to [account_type, @team],
        success: t("controllers.teams.update.success")
    else
      render :edit
    end
  end

  private
  def team_params
    params.require(:team).permit(
      :name,
      :description,
      :team_photo,
      :team_photo_cache,
      :accepting_student_requests,
      :accepting_mentor_requests,
      :city,
      :state_province,
      :country,
    ).tap do |tapped|
      unless params.fetch(:id) { false }
        tapped[:division] = Division.for(current_profile)
      end
    end
  end
end
