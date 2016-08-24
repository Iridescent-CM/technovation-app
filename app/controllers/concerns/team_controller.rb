module TeamController
  extend ActiveSupport::Concern

  included do
    helper_method :account_type
  end

  def show
    @team = current_account.teams.find(params.fetch(:id))
    @team_member_invite = TeamMemberInvite.new(team_id: @team.id)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to [account_type, @team],
        success: t("controllers.#{account_type}.teams.create.success")
    else
      render :new
    end
  end

  def edit
    @team = current_account.teams.find(params.fetch(:id))
  end

  def update
    @team = current_account.teams.find(params.fetch(:id))

    if @team.update_attributes(team_params)
      redirect_to [account_type, @team],
        success: t("controllers.#{account_type}.teams.update.success")
    else
      render :edit
    end
  end

  private
  def team_params
    params.require(:team).permit(:name, :description).tap do |tapped|
      unless params.fetch(:id) { false }
        tapped[:division] = Division.for(current_account)
        tapped["#{account_type}_ids"] = current_account.id
      end
    end
  end

  def account_type
    current_account.type_name
  end
end
