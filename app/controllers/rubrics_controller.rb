class RubricsController < ApplicationController
  
  def new
    ## new rubric needs to take a team
    @rubric = Rubric.new
  	@rubric.team = Team.friendly.find(params[:team])
    authorize @rubric
  end

  def show    
    @rubric = Rubric.find(params[:id])
    authorize @rubric
  end

  def index
  	teams = Team.all
    ## do not show teams that the judge has judged already
    ## search for teams that have the fewest number of rubrics

  	ind = rand(teams.length)
  	@team = teams[ind]
 

    ## only show rubrics that were done by the current judge
  	@rubrics = Rubric.all.has_judge(current_user)


    ## if the judge is signed up for an event, and it is currently the time of the event, only show teams that are signed up for the event
    ## if the judge is a mentor/coach, do not show teams from the same region
  end

  def edit
  	## find the team associated with the rubric
  	@rubric = Rubric.find(params[:id])
  	@team = @rubric.team
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

  def rubric_type
    ## todo: this seems sketchy
    if between?(Setting.quarterfinalJudgingOpen, Setting.quarterfinalJudgingClose)
      return 'quarterfinal'
    end
    if between?(Setting.semifinalJudgingOpen, Setting.semifinalJudgingClose)
      return 'semifinal'
    end
    if past?(Setting.semifinalJudgingClose)
      return 'final'
    end
  end

  private

  def rubric_params
  	params.require(:rubric).permit(:team_id, :identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :launched, :pitch, :identify_problem_comment, :address_problem_comment, :functional_comment, :external_resources_comment, :match_features_comment, :interface_comment, :description_comment, :market_comment, :competition_comment, :revenue_comment, :branding_comment, :pitch_comment, :launched_comment, )
  end
end
