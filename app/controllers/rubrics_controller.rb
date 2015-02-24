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

  	## todo change to only teams whose submissions are complete
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

  private
    def rubric_params
    	params.require(:rubric).permit(:identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :launched, :pitch, :team_id)
    end
end
