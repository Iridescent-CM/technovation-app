module TeamController
  extend ActiveSupport::Concern

  included do
    rescue_from "ActiveRecord::RecordNotFound" do |e|
      redirect_to send("#{current_scope}_dashboard_path"),
        alert: "You are not a member of that team!"
    end
  end

  def show
    @team = current_profile.teams.find(params.fetch(:id))
    @team_member_invite = TeamMemberInvite.new(team_id: @team.id)
    @uploader = ImageUploader.new
    @uploader.success_action_redirect = send(
      "#{current_scope}_team_photo_upload_confirmation_url",
      team_id: @team.id,
      back: request.fullpath
    )
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      RegisterToCurrentSeasonJob.perform_later(@team)
      TeamRosterManaging.add(@team, current_profile)

      redirect_to [current_scope, @team],
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

    if TeamUpdating.execute(@team, team_params)
      respond_to do |format|
        format.json {
          render json: {
            flash: {
              success: t("controllers.teams.update.success"),
            },
          },
          status: 200
        }

        format.html {
          redirect_to [current_scope, @team],
            success: t("controllers.teams.update.success")
        }
      end
    else
      respond_to do |format|
        format.json {
          render json: {
            flash: {
              alert: t("controllers.teams.update.failure"),
              errors: @team.errors.full_messages,
            },
          },
          status: 422
        }

        format.html {
          render :edit
        }
      end
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
