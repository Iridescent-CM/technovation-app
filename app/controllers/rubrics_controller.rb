class RubricsController < ApplicationController
  before_action :authenticate_user!

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
    ## if the judge is signed up for an in-person event
    ## and it is currently the time of the event, only show teams that are signed up for the event
    event_active = false
    if not current_user.event_id.nil?
      event = Event.find(current_user.event_id)
      if not event.is_virtual? && Setting.anyJudgingRoundActive?
        round = Setting.judgingRound
        start = Setting.get_date(round+'JudgingOpen')
        finish = Setting.get_date(round+'JudgingClose')

        if (start..finish).cover?(Setting.now)
          teams = Team.all.has_event(event)
          @event = event
          event_active = true
        end
      end
    end

    if Setting.judgingRound == 'quarterfinal'
      if !event_active
        ## if it is the quarterfinals and it is not the time of the judge's event
        ## only show teams who have signed up for Virtual Judging
        id = Event.virtual_for_current_season.id
        teams = Team.where(region: current_user.judging_region, event_id: id)
      end
    elsif Setting.judgingRound == 'semifinal' and current_user.semifinals_judge?
      teams = Team.where(issemifinalist: true)
    elsif Setting.judgingRound == 'final' and current_user.finals_judge?
      teams = Team.where(isfinalist: true)
    else
      teams = Team.none
    end
    
    ## search for teams that have the fewest number of rubrics
    teams = teams.sort_by(&:num_rubrics)

    ## do not show teams that the judge has judged already
    teams.delete_if{|team| team.judges.map{|j| j.id}.include? current_user.id }

    ## remove the teams who are not eligible
    teams.delete_if{|t| t.ineligible?}

    ## remove teams that have entered less than five fields of information
    teams.delete_if{|t| !t.submission_eligible?}

    if current_user.home_country == 'BR'
      teams.delete_if{ |team| team.country != 'BR' }
    else
      teams.delete_if{ |team| team.country == 'BR' }
    end

    if event_active
      ## show all teams for in-person events
      @teams = teams
    else
      ## show a randomly drawn team with the minimum number rubrics for virtual judging
      if teams.length > 0
        teams.keep_if{|t| t.num_rubrics == teams[0].num_rubrics}
        @teams = [ teams.sample ]
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
      @rubric_is_new = true
      render :new
    end
  end

  private

  def rubric_params
    params.require(:rubric).permit(:team_id, :identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :launched, :pitch, :identify_problem_comment, :address_problem_comment, :functional_comment, :external_resources_comment, :match_features_comment, :interface_comment, :description_comment, :market_comment, :competition_comment, :revenue_comment, :branding_comment, :pitch_comment, :launched_comment, )
  end
end
