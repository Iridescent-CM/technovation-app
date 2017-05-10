module Legacy
  module V2
    module Student
      class TeamSearchesController < StudentController
        def new
          params[:nearby] = current_student.address_details if params[:nearby].blank?
          params[:division_enums] ||= Division.names.values

          if params[:division_enums].respond_to?(:keys)
            params[:division_enums] = params[:division_enums].keys.flatten.distinct
          end

          @search_filter = SearchFilter.new({
            nearby: params.fetch(:nearby),
            user: current_student,
            spot_available: true,
            text: params[:text],
            division_enums: params[:division_enums],
          })

          @teams = SearchTeams.(@search_filter).paginate(page: params[:page])
        end
      end
    end
  end
end
