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
#      @teams = Team.where(year: Setting.year).shuffle
#      @mentors = apply_scopes(policy_scope(User)).mentor.has_expertise
#      binding.pry
      @teams = apply_scopes(Team.where(year: Setting.year))

      unless params[:category].nil?
        @teams = @teams.has_category(params[:category])
      end
      unless params[:region].nil?
        @teams = @teams.has_region(params[:region])
      end
      unless params[:division].nil?
        @teams = @teams.has_division(params[:division])
      end
      
      @teams.shuffle

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

  def submit
    @team = Team.friendly.find(params[:id])
    authorize @team

    ## send out the mail
    for user in @team.members
      SubmissionMailer.submission_received_email(user, @team)
    end

    flash[:notice] = 'Submission Received'
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
    params.require(:team).permit(:category_id, :name, :about, :avatar, :region, :code, :logo, :pitch, :demo, :plan, :description, :screenshot1, :screenshot2, :screenshot3, :screenshot4, :screenshot5, :event_id, :store)
  end

end
