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
    find_event_and_teams
    @teams = select_teams_for_current_judging_round
    @teams = select_eligible_teams
    @teams = select_teams_based_on_judge_home_country
    @teams = select_random_teams_judged_the_same
    @rubrics = current_user.rubrics.where("extract(year from created_at) = ?",
                                          Setting.year)
  end

  def edit
    @rubric = Rubric.find(params[:id])
    @team = @rubric.team # Why not use @rubric.team in the view?
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

    authorize @rubric
    if @rubric.save
      redirect_to :rubrics
    else
      render :new
    end
  end

  private
  def find_event_and_teams
    if current_user.event
      @event = current_user.event
      @teams = if not @event.is_virtual? && Setting.anyJudgingRoundActive?
                 @event.teams
               else
                 []
               end
    else
      @event = NoEvent.new
      @teams = []
    end
  end

  def select_teams_for_current_judging_round
    case Setting.judgingRound
    when 'quarterfinal'
      if @event.is_virtual?
        @event = Event.virtual_for_current_season
        @event.teams.where(region: current_user.judging_region)
      else
        @teams
      end
    when 'semifinal'
      if current_user.semifinals_judge?
        Team.is_semi_finalist
      else
        @teams
      end
    when 'final'
      if current_user.finals_judge?
        Team.is_finalist
      else
        @teams
      end
    else
      Team.none
    end
  end

  def select_eligible_teams
    @teams.reject { |team| team.judges.include?(current_user) }
          .reject(&:ineligible?)
          .select(&:submission_eligible?)
  end

  def select_teams_based_on_judge_home_country
    if current_user.home_country == 'BR'
      @teams.select { |team| team.country == 'BR' }
    else
      @teams.select { |team| team.country != 'BR' }
    end
  end

  def select_random_teams_judged_the_same
    if @event.is_virtual? && Setting.anyJudgingRoundActive?
      @teams.sort_by(&:num_rubrics)
            .select { |t| t.num_rubrics == @teams[0].num_rubrics }
            .sample(3)
    else
      @teams
    end
  end

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
end
