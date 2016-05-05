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
    ## if the judge is signed up for an in-person event
    ## and it is currently the time of the event,
    ## only show teams that are signed up for the event
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

    case Setting.judgingRound

    when 'quarterfinal'
      if !event_active
        id = Event.virtual_for_current_season.id
        teams = Team.where(region: current_user.judging_region, event_id: id)
      end

    when 'semifinal'
      teams = Team.where(is_semi_finalist: true) if current_user.semifinals_judge?

    when 'final'
      teams = Team.where(isfinalist: true) if current_user.finals_judge?

    else
      teams = Team.none
    end

    teams = teams
            .sort_by(&:num_rubrics)
            .delete_if { |team| team.judges.map{|j| j.id }.include? current_user.id }
            .delete_if { |team| team.ineligible? }
            .delete_if { |team| !team.submission_eligible? }

    teams = if current_user.home_country == 'BR'
              teams.delete_if { |team| team.country != 'BR' }
            else
              teams.delete_if { |team| team.country == 'BR' }
            end

    @teams = teams

    unless event_active
      ## show a randomly drawn team with
      ## the minimum number rubrics
      ## for virtual judging
      unless teams.empty?
        teams.keep_if { |t| t.num_rubrics == teams[0].num_rubrics }
        @teams = teams.sample(3)
      end
    end

    ## show all past rubrics that were
    ## done by the current judge for editing
    @rubrics = Rubric.where("extract(year from created_at) = ?", Setting.year).has_judge(current_user)

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
