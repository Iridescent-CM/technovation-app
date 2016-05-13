class RubricsController < ApplicationController
  before_action :authenticate_user!

  def new
    @rubric = Rubric.new(team: Team.friendly.find(params[:team]))
    authorize @rubric
  end

  def show
    @rubric = Rubric.find(params[:id])
    authorize @rubric
  end

  def index
    judging = Judging.new(current_user)

    @event = judging.event

    @quarterfinal_teams = judging.teams(:quarterfinal)
    @semifinal_teams = judging.teams(:semifinal)

    @quarterfinal_rubrics = current_user.rubrics.quarterfinal
    @semifinal_rubrics = current_user.rubrics.semifinal
  end

  def edit
    @rubric = Rubric.find(params[:id])
    authorize @rubric
  end

  def update
    @rubric = Rubric.find(params[:id])
    authorize @rubric

    if @rubric.update(rubric_params)
      @rubric.user_id = current_user.id
      @rubric.save
      redirect_to :rubrics
    else
      redirect_to :back
    end
  end

  def create
    @rubric = Rubric.new(rubric_params)
    @rubric.team = Team.find(@rubric.team_id)
    @rubric.user_id = current_user.id
    @rubric.stage = Setting.judgingRound

    authorize @rubric
    if @rubric.save
      redirect_to :rubrics
    else
      render :new
    end
  end

  private
  def rubric_params
    params.require(:rubric).permit(
      :team_id, :identify_problem, :address_problem, :functional,
      :external_resources, :match_features, :interface, :description,
      :market, :competition, :revenue, :branding, :launched, :pitch,
      :identify_problem_comment, :address_problem_comment,
      :functional_comment, :external_resources_comment,
      :match_features_comment, :interface_comment, :description_comment,
      :market_comment, :competition_comment, :revenue_comment,
      :branding_comment, :pitch_comment, :launched_comment
    )
  end

  def pundit_user
    UserContext.new(current_user, request.referer)
  end
end
