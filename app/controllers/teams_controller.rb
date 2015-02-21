class TeamsController < ApplicationController
  before_action :authenticate_user!, except: :index

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
      @teams = Team.where(t[:name].matches('%'+@search+'%'))
      @season = "All Seasons"
    else
      @teams = Team.where(year: Setting.year)
      @season = "#{Setting.year} Season"
    end
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
    if @team.update(team_params)
      redirect_to @team
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

  # def update_submissions
  #   # binding.pry
  #   @team = Team.friendly.find(params[:id])
  #   authorize @team
  #   params[:team][:submission_attachment].map { |k, v| sa = SubmissionAttachment.new({link: k, variety: 1, team_id: params[:id]}); sa.save! }

  #   redirect_to @team
  # end

  private
  def team_params
    params.require(:team).permit(:category_id, :name, :about, :avatar, :region, :code, :logo, :pitch, :demo, :plan, :description, :screenshot1, :screenshot2, :screenshot3, :screenshot4, :screenshot5)
  end

end
