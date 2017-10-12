module Mentor
  class TeamSearchesController < MentorController
    def new
      if current_mentor.latitude.blank?
        redirect_to mentor_location_details_path(return_to: request.fullpath),
          notice: "Please save your location so that you can search for nearby teams"
      end

      params[:nearby] = current_mentor.address_details if params[:nearby].blank?
      params[:division_enums] ||= Division.names.values

      if params[:division_enums].respond_to?(:keys)
        params[:division_enums] = params[:division_enums].keys.flatten.distinct
      end

      @search_filter = SearchFilter.new({
        nearby: params.fetch(:nearby),
        scope: current_scope,
        has_mentor: :any,
        text: params[:text],
        division_enums: params[:division_enums] || [],
        country: current_mentor.country,
        location: current_mentor.address_details,
      })

      @teams = SearchTeams.(@search_filter).paginate(page: params[:page])
    end
  end
end
