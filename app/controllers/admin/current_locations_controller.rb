module Admin
  class CurrentLocationsController < AdminController
    def show
      if account_id = params.fetch(:account_id) { false }
        record = Account.find(account_id)
      else
        record = Team.find(params.fetch(:team_id))
      end

      state = FriendlySubregion.(record, prefix: false)
      state_code = FriendlySubregion.(record, {
        prefix: false,
        short_code: true
      })

      friendly_country = FriendlyCountry.new(record)

      render json: {
        city: record.city,
        state: state,
        state_code: state_code,
        country: friendly_country.country_name,
        country_code: friendly_country.as_short_code,
      }
    end
  end
end