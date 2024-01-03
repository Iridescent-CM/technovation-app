module Student
  class CurrentLocationsController < StudentController
    def show
      record = if params.fetch(:team_id) { false }
        current_team
      else
        current_account
      end

      friendly_country = FriendlyCountry.new(record)

      state = FriendlySubregion.call(record, prefix: false)
      state_code = FriendlySubregion.call(record, {
        prefix: false,
        short_code: true
      })

      json = {
        city: record.city,
        state: state,
        state_code: state_code,
        country: friendly_country.country_name,
        country_code: friendly_country.as_short_code
      }

      render json: json
    end
  end
end
