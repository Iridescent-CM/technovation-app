class RubricsController < ApplicationController
  
  def show    
    @rubric = Rubric.find(params[:id])
    authorize @rubric
  end

  def new
    ## new rubric needs to take a team
    @rubric = Rubric.new
  	@rubric.team = Team.friendly.find(params[:team])
    authorize @rubric
  end

  def index
  	# @rubric = Rubric.friendly.find(params[:id])
  	teams = Team.all
  	ind = rand(teams.length)

  	@team = teams[ind]
 
  	@rubrics = Rubric.all

    ## only show rubrics that were done by the judge
    ## do not show teams that the judge has judged already
    ## if the judge is signed up for an event, and it is currently the time of the event, only show teams that are signed up for the event
    ## search for teams that have the fewest number of submissions
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
    # redirect_to :rubrics

    if @rubric.update(rubric_params)
      redirect_to :rubrics
    else
      redirect_to :back
    end

  end   

  def create
  	@rubric = Rubric.new(rubric_params)
    @rubric.team = Team.find(@rubric.team_id)
    authorize @rubric

    # binding.pry

  	if @rubric.save
  	  redirect_to :rubrics
  	else
  	  render :new
  	end
  end

  def rubric_type
    if between?(Setting.quarterfinalJudgingOpen, Setting.quarterfinalJudgingClose)
      return 'quarterfinal'
    if between?(Setting.semifinalJudgingOpen, Setting.semifinalJudgingClose)
      return 'semifinal'
    if past?(Setting.semifinalJudgingClose)
      return 'final'
  end

  private
    # def can_see_rubric?
    #   ## todo: depends whether this is a quaterfinal, semifinal, or final rubric
    #   ## get the rubric type
    #   ## see if the judging for that type has closed
    # end

    def rubric_params
    	params.require(:rubric).permit(:identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :launched, :pitch, :team_id)
    end
end
