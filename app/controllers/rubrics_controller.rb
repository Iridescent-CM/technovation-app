class RubricsController < ApplicationController
  
  def show    
    @rubric = Rubric.find(params[:id])
    authorize @rubric
  end

  def new
    ## new rubric needs to take a team
    @rubric = Rubric.new
  	@rubric.team = Team.friendly.find(params[:team])

#    binding.pry
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

    if @rubric.update(rubric_params)
      @rubric.score = calculate_score
      @rubric.user_id = current_user.id

      @rubric.save

      # @rubric.team.rubrics_count = @rubric.team.rubrics.length
      # scores = @rubric.team.rubrics.map{|r| r.score}
      # @rubric.team.rubrics_average = scores.inject(:+).to_f / scores.size #average(scores) # 
      # @rubric.team.save
#      binding.pry

      redirect_to :rubrics
    else
      redirect_to :back
    end

  end   

  def create
  	@rubric = Rubric.new(rubric_params)
    @rubric.team = Team.find(@rubric.team_id)
    @rubric.score = calculate_score
    @rubric.user_id = current_user.id
    
    authorize @rubric
  	if @rubric.save
      # @rubric.team.rubrics_count = @rubric.team.rubrics.length
      # scores = @rubric.team.rubrics.map{|r| r.score}
      # @rubric.team.rubrics_average = scores.inject(:+).to_f / scores.size #average(scores) #
      # @rubric.team.save

  	  redirect_to :rubrics
  	else
  	  render :new
  	end
  end

  def rubric_type
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
  def calculate_score
    score = 0
    points = [:identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :pitch]
    points.each { |p| score += @rubric[p]}

    if @rubric.launched
      score += 2
    end

    # deduct points for missing components (todo)
    #missing_field?(a)
    deductions = [:pitch, :demo, :code, :description, :plan]
    deductions.each{ |d| 
      if (@rubric.team.missing_field?(d.to_s))
        score -= 1
      end
    }

    deductions = [:screenshot1, :screenshot2, :screenshot3, :screenshot4, :screenshot5]
    if deductions.map{|d| @rubric.team.missing_field?(d.to_s)}.all?
      ## if all screenshots are missing then deduct 1 pt
      score -= 1
    end

    score
  end

  def can_see_rubric?
    ## todo: depends whether this is a quaterfinal, semifinal, or final rubric
    ## get the rubric type
    ## see if the judging for that type has closed
  end

  def rubric_params
  	params.require(:rubric).permit(:team_id, :identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :launched, :pitch, :identify_problem_comment, :address_problem_comment, :functional_comment, :external_resources_comment, :match_features_comment, :interface_comment, :description_comment, :market_comment, :competition_comment, :revenue_comment, :branding_comment, :pitch_comment, :launched_comment, )
  end
end
