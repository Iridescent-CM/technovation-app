module Student
  class CurrentLocationsController < StudentController
    def show
      record = if params.fetch(:team_id) { false }
                 current_team
               else
                 current_account
               end

      country = FriendlyCountry.new(record).country_name

      render json: {
        city: record.city,
        state: FriendlySubregion.(record, prefix: false),
        state_code: record.state_province,
        country: country,
        country_code: record.country,
      }
    end
  end
end