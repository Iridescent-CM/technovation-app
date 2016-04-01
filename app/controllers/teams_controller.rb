class TeamsController < ApplicationController
  before_action :authenticate_user!, except: :index

  has_scope :has_category
  has_scope :has_division
  has_scope :has_region

  def new
    @team = Team.new
    authorize @team
  end

  def show
    @team = Team.friendly.find(params[:id])
    authorize @team
  end

  def index

    if params[:search]
      @search = params[:search]
      t = Team.arel_table
      @teams = Team.where(t[:name].matches('%'+@search+'%')).shuffle
      @season = "All Seasons"
    else
      @teams = apply_scopes(Team.all)

      if params[:previous_years].nil?
        @teams = @teams.where(year: Setting.year)
        @season = "#{Setting.year} Season"
      else
        @season = "All Seasons"
        @previous_years = true
      end
      unless params[:category].nil?
        @teams = @teams.where(category: params[:category])
        @category = params[:category]
      end
      unless params[:region].nil?
        @teams = @teams.where(region: params[:region])
        @region = params[:region]
      end
      unless params[:division].nil?
        @teams = @teams.where(division: params[:division])
        @division = params[:division]
      end
      unless params[:issemifinalist].nil?
        @teams = @teams.is_semifinalist
        @issemifinalist = true
      end
      unless params[:isfinalist].nil?
        @teams = @teams.is_finalist
        @isfinalist = true
      end
      unless params[:iswinner].nil?
        @teams = @teams.is_winner
        @iswinner = true
      end
      # unless params[:showincomplete] == 'true'
      #   @teams = @teams.is_submitted
      #   @showincomplete = true
      # end

      @teams = @teams.shuffle

    end

    render layout: 'noprofile'
  end

  def create
    @team = Team.new(team_params)
    @team.year = Setting.year
    authorize @team

    Team.transaction do
      @team.save!
      @team_request = TeamRequest.new({
        user: current_user,
        team: @team,
        user_request: true,
        approved: true,
      }).save!
    end
    redirect_to @team

  rescue ActiveRecord::RecordInvalid => exception
    flash.now[:alert] = exception
    render :new
  end

  def update
    @team = Team.friendly.find(params[:id])
  
    authorize @team
    if @team.update(update_params)
      if params[:team][:event_signup]
        flash[:notice] = 'Event signup updated'
        redirect_to :back
      else
        redirect_to @team
      end
    else
      redirect_to :back
    end
  end

  def edit
    @team = Team.friendly.find(params[:id])
    authorize @team
  end

  def join
    @team = Team.friendly.find(params[:id])
    authorize @team
    @team.team_requests << TeamRequest.new(
      user: current_user,
      team: @team,
      approved: false,
      user_request: true
    )
    if @team.save
      flash[:notice] = 'Team Request Sent'
    else
      flash[:alert] = 'Error'
    end
    redirect_to @team
  end

  def event_signup
    @team = Team.friendly.find(params[:id])
    authorize @team
  end

  def edit_submission
    @team = Team.friendly.find(params[:id])
    authorize @team

    # if @team.update(team_params)
    #   if params[:team][:event_signup]
    #     flash[:notice] = 'Event signup updated'
    #     redirect_to :back
    #   else
    #     redirect_to @team
    #   end
    # else
    #   redirect_to :back
    # end
  end

  # def update_submissions
  #   # binding.pry
  #   @team = Team.friendly.find(params[:id])
  #   authorize @team
  #   params[:team][:submission_attachment].map { |k, v| sa = SubmissionAttachment.new({link: k, variety: 1, team_id: params[:id]}); sa.save! }

  #   redirect_to @team
  # end

  private

  def update_params
    default_values = { confirm_region: false }
    return default_values.merge(team_params) if Setting.get_boolean('manual_region_selection')
    team_params
  end

  def team_params
    params.require(:team)
      .permit(:category_id, :name, :about, :avatar, :region_id, :code, :logo, :pitch, :demo, :plan, :description, :screenshot1, :screenshot2, :screenshot3, :screenshot4, :screenshot5, :event_id, :store, :tools, :android, :ios, :windows, :challenge, :participation, :confirm_region)
  end

end
