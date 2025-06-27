module MentorTeamDetailsConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_team
  end

  private

  def set_team
    @team = current_profile.teams.find(params[:team_id])
  end
end