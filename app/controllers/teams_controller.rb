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
      @teams = apply_scopes(Team.where(year: Setting.year))

      unless params[:category].nil?
        @teams = @teams.where(category: params[:category])
      end
      unless params[:region].nil?
        ## calculate a real region id from the division and the geographic region coming in
        if params[:division].nil? or params[:division].length == 2
          regions_hs = params[:region].map{|r| r.to_i}
          regions_ms = regions_hs.map{|r| r + 4}
          @teams = @teams.where(region: regions_hs+regions_ms)  
        elsif params[:division].length == 1
          ## flip the bit
          division = (params[:division][0].to_i - 1).abs
          converted = params[:region].map{|r| division * 4 + r.to_i}
          @teams = @teams.where(region: converted)
        end
      end
      unless params[:division].nil?
        @teams = @teams.where(division: params[:division])
      end
      unless params[:issemifinalist].nil?
        @teams = @teams.is_semifinalist
      end
      unless params[:isfinalist].nil?
        @teams = @teams.is_finalist
      end
      unless params[:iswinner].nil?
        @teams = @teams.is_winner
      end
      unless params[:showincomplete] == 'true'
        @teams = @teams.is_submitted
      end

      @teams = @teams.shuffle

      @season = "#{Setting.year} Season"
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
  def team_params
    params.require(:team).permit(:category_id, :name, :about, :avatar, :region, :code, :logo, :pitch, :demo, :plan, :description, :screenshot1, :screenshot2, :screenshot3, :screenshot4, :screenshot5, :event_id, :store, :tools, :android, :ios, :windows, :challenge, :participation)
  end

end
