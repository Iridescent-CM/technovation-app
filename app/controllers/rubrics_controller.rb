class RubricsController < ApplicationController
  
  def new
    ## new rubric needs to take a team
    @rubric = Rubric.new
  	@rubric.team = Team.friendly.find(params[:team])

    @rubric_is_new = true
    authorize @rubric
  end

  def show    
    @rubric = Rubric.find(params[:id])
    authorize @rubric
  end

  def index
    if Setting.stage == 'quarterfinal'
    	teams = Team.where(region: current_user.judging_region)
    elsif Setting.stage == 'semifinal'
      teams = Team.where(issemifinalist: true, region: current_user.judging_region)
    elsif Setting.stage == 'final'
      teams = Team.where(isfinalist: true, region: current_user.judging_region)
    end

    ## if the judge is signed up for an in-person event
    ## and it is currently the time of the event, only show teams that are signed up for the event
    event_active = false
    if not current_user.event_id.nil?
      event = Event.find(current_user.event_id)
      if event.name != 'Virtual Judging'
        start = (event.whentooccur - 3.hours).to_datetime
        finish = (event.whentooccur + 10.hours).to_datetime
        if (start..finish).cover?(Setting.now)
          ## only show the teams competing in the event
          teams = teams.has_event(event)
          @event = event
          event_active = true
        end
      end
    end

    ## if it is the quarterfinals and it is not the time of the judge's event
    ## only show teams who have signed up for Virtual Judging
    if Setting.stage == 'quarterfinal' and !event_active
      id = Event.where(name: 'Virtual Judging').first.id
      teams = Team.where(event_id: id)
    end

    ## search for teams that have the fewest number of rubrics
    teams = teams.sort_by(&:num_rubrics)

    ## do not show teams that the judge has judged already
    teams.delete_if{|team| team.judges.map{|j| j.id}.include? current_user.id }


    ## todo: conflict_region should be assigned correctly for both judge user types and for mentor/coach turned judges
    ## todo: judging_region should be assigned correctly for judges signed up for in-person events (and based on conflict_region)
    # ## if the judge is a mentor/coach, do not show teams from the same region
    # if current_user.coach? or current_user.mentor?
    #   interested_regions = current_user.teams.map{|t| t.region}
    #   teams.delete_if{|t| interested_regions.include? t.region}
    # end

    # ## if the judge was a mentor/coach, but this is not a mentor coach account (late signups)
    # unless current_user.conflict_region.nil? 
    #   teams.delete_if{|t| current_user.conflict_region == Team.regions[t.region]}
    # end

    # ## judges should only judge within one region for score normalization purposes
    # unless current_user.judging_region.nil?
    #   teams.keep_if{|t| current_user.judging_region == Team.regions[t.region]}
    # end

    ## remove the teams who have division == x
    teams.delete_if{|t| t.division == 'x'}

    if event_active
      ## show all teams for in-person events
      @teams = teams
    else
      ## show a randomly drawn team with the minimum number rubrics for virtual judging
      if teams.length > 0
        teams.keep_if{|t| t.num_rubrics == teams[0].num_rubrics}
        ind = rand(teams.length)
        @teams = [ teams[ind] ]
      end    
    end


    ## show all past rubrics that were done by the current judge for editing
  	@rubrics = Rubric.all.has_judge(current_user)

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
