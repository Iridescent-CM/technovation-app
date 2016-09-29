module Mentor
  class MentorSearchesController < MentorController
    def new
      params[:nearby] = current_mentor.address_details if params[:nearby].blank?
      params[:needs_team] = false if params[:needs_team].blank?

      @search_filter = SearchFilter.new(search_filter_params)
      @expertises = Expertise.all
      @mentors = SearchMentors.(@search_filter).paginate(page: params[:page])
    end

    private
    def search_filter_params
      params.fetch(:search_filter) { {} }.merge({
        nearby: params.fetch(:nearby),
        user: current_mentor,
        needs_team: params.fetch(:needs_team),
      })
    end
  end
end
