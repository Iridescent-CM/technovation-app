module Mentor
  class TeamSearchesController < MentorController
    def new
      @search_filter = SearchFilter.new({
        nearby: current_mentor.address_details,
        has_mentor: false,
        page: params[:page],
      })
      @teams = SearchTeams.(@search_filter)
    end
  end
end
