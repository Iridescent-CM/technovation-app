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

    if @team.current?
      @team_member_invite = TeamMemberInvite.new(team_id: @team.id)
      @uploader = ImageDirectUploader.new
      @uploader.success_action_redirect = send(
        "#{current_scope}_team_photo_upload_confirmation_url",
        team_id: @team.id,
        back: request.fullpath
      )
    elsif @team.past?
      render 'teams/past'
    end
  end

  def new
    @team = Team.new(name: params[:name])
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      TeamCreating.execute(@team, current_profile, self)
    else
      render :new
    end
  end

  def edit
    @team = current_profile.teams.find(params.fetch(:id))
  end

  def update
    @team = current_profile.teams.find(params.fetch(:id))

    if TeamUpdating.execute(@team, team_params, current_account)
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
        tapped["#{current_scope}_ids"] ||= []
        tapped["#{current_scope}_ids"].push(current_profile.id)
      end
    end
  end
end
