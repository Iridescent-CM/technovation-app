module Mentor
  class TeamSearchesController < MentorController
    def new
      params[:nearby] = current_mentor.address_details if params[:nearby].blank?

      @search_filter = SearchFilter.new({
        nearby: params.fetch(:nearby),
        user: current_mentor,
        has_mentor: false,
        page: params[:page],
      })
      @teams = SearchTeams.(@search_filter)
    end
  end
end
