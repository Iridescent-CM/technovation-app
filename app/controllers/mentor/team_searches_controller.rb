module Mentor
  class TeamSearchesController < MentorController
    def new
      params[:nearby] = current_mentor.address_details if params[:nearby].blank?
      params[:division_enums] ||= Division.names.values

      @search_filter = SearchFilter.new({
        nearby: params.fetch(:nearby),
        user: current_mentor,
        has_mentor: :any,
        text: params[:text],
        division_enums: params[:division_enums],
      })

      @teams = SearchTeams.(@search_filter).paginate(page: params[:page])
    end
  end
end
